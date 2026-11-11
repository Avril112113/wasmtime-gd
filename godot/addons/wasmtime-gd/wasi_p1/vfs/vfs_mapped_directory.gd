extends Wasip1VfsDirectoryBase
class_name Wasip1VfsMappedDirectory


var _real_path: String
var _children: Dictionary[String, WeakRef]


# TODO: Verify that `= {}` creates a new dirctionary every time.
func _init(vfs: Wasip1Vfs, real_path: String, _children: Dictionary[String, WeakRef] = {}) -> void:
	super._init(vfs)
	self._real_path = real_path
	self._children = _children

func get_access_time() -> int:
	return self.vfs.epoch_nsec

func get_modify_time() -> int:
	return self.vfs.epoch_nsec

func get_create_time() -> int:
	return self.vfs.epoch_nsec

## [param path] is the full relative path.
## Returns [Wasip1VfsEntryBase] or [enum Wasip1Consts.Errno]
func get_child(path: String) -> Variant:
	var child_path = self._real_path.path_join(path).simplify_path()
	if not (child_path.begins_with(self._real_path) and child_path.substr(len(self._real_path), 1) == "/"):
		return Wasip1Consts.Errno.ENOENT
	if child_path in self._children:
		return self._children[child_path].get_ref()
	if DirAccess.dir_exists_absolute(child_path):
		var child := Wasip1VfsMappedDirectory.new(self.vfs, child_path, self._children)
		self._children[child_path] = weakref(child)
		return child
	elif FileAccess.file_exists(child_path):
		var child := Wasip1VfsMappedFile.new(self.vfs, child_path)
		self._children[child_path] = weakref(child)
		return child
	return Wasip1Consts.Errno.ENOENT

func open() -> FdHandle:
	return FdHandle.new(self)


class FdHandle:
	extends Wasip1VfsHandle
	
	var _entry: Wasip1VfsMappedDirectory
	
	func _init(entry: Wasip1VfsMappedDirectory) -> void:
		super._init(entry)
		self._entry = entry

	func fd_readdir() -> Wasip1Consts.Errno:
		# TODO: Implement this
		return Wasip1Consts.Errno.ENOSYS
