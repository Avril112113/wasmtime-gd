extends Wasip1VfsDirectoryBase
class_name Wasip1VfsVirtualDirectory


var _access_time: int
var _modify_time: int
var _create_time: int
var _children: Dictionary[String,Wasip1VfsEntryBase] = {}


func _init(vfs: Wasip1Vfs) -> void:
	super._init(vfs)
	self._create_time = vfs._clock.now_nsec
	self._access_time = self._create_time
	self._modify_time = self._create_time

func get_access_time() -> int:
	return self._access_time

func get_modify_time() -> int:
	return self._modify_time

func get_create_time() -> int:
	return self._create_time

## [param path] is the full relative path.
## Returns [Wasip1VfsEntryBase] or [Wasip1Consts.Errno]
func get_child(path: String) -> Variant:
	self._access_time = self.vfs._clock.now_nsec
	var parts = path.split("/", true, 1)
	if parts[0] in self._children:
		var child := _children[parts[0]]
		if len(parts) >= 2:
			if child is Wasip1VfsDirectoryBase:
				return child.get_child(parts[1])
			else:
				return Wasip1Consts.Errno.ENOTDIR
		else:
			return child
	return Wasip1Consts.Errno.ENOENT

## Returns `true` if added, otherwise `false` if it failed.
func add_child(name: String, entry: Wasip1VfsEntryBase) -> bool:
	self._access_time = self.vfs._clock.now_nsec
	if name in self._children:
		return Wasip1Consts.Errno.EEXIST
		
	self._modify_time = self.vfs._clock.now_nsec
	entry.parent = self
	self._children[name] = entry
	return Wasip1Consts.Errno.ESUCCESS

func open() -> FdHandle:
	return FdHandle.new(self)


class FdHandle:
	extends Wasip1VfsHandle
	
	var _entry: Wasip1VfsVirtualDirectory
	
	func _init(entry: Wasip1VfsVirtualDirectory) -> void:
		super._init(entry)
		self._entry = entry

	func fd_readdir() -> Wasip1Consts.Errno:
		# TODO: Implement this
		return Wasip1Consts.Errno.ENOSYS
