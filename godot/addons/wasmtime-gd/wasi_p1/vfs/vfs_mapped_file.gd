extends Wasip1VfsFileBase
class_name Wasip1VfsMappedFile


var _real_path: String


func _init(vfs: Wasip1Vfs, real_path: String) -> void:
	super._init(vfs)
	self._real_path = real_path

func get_filesize() -> int:
	return FileAccess.get_size(self._real_path)

func get_access_time() -> int:
	return self.vfs.epoch_nsec

func get_modify_time() -> int:
	return self.vfs.epoch_nsec

func get_create_time() -> int:
	return self.vfs.epoch_nsec

func open() -> FdHandle:
	# TODO: Rights for reading and/or writing
	var f := FileAccess.open(_real_path, FileAccess.READ)
	if f == null:
		# no way to propogate the error, it's not that important anyway, it'll just be a ENOENT.
		return null
	return FdHandle.new(self, f)


class FdHandle:
	extends Wasip1VfsHandle
	
	var _entry: Wasip1VfsMappedFile
	
	var _f: FileAccess
	
	func _init(entry: Wasip1VfsMappedFile, f: FileAccess) -> void:
		super._init(entry)
		self._entry = entry
		self._f = f
	
	func fd_read(bytes: PackedByteArray, count: int) -> Wasip1Consts.Errno:
		bytes.append_array(self._f.get_buffer(count))
		return Wasip1Consts.Errno.ESUCCESS
	
	func fd_write(bytes: PackedByteArray) -> Wasip1Consts.Errno:
		if self._f.store_buffer(bytes):
			bytes.clear()
			return Wasip1Consts.Errno.ESUCCESS
		return Wasip1Consts.Errno.ENOTCAPABLE
	
	func fd_seek(offset: int, whence: Wasip1Consts.Whence) -> Array[int]:
		match whence:
			Wasip1Consts.Whence.CUR:
				self._f.seek(self._f.get_position() + offset)
				return [Wasip1Consts.Errno.ESUCCESS, self._f.get_position()]
			Wasip1Consts.Whence.SET:
				self._f.seek(offset)
				return [Wasip1Consts.Errno.ESUCCESS, self._f.get_position()]
			Wasip1Consts.Whence.END:
				self._f.seek_end(offset)
				return [Wasip1Consts.Errno.ESUCCESS, self._f.get_position()]
		return [Wasip1Consts.Errno.EINVAL, self._f.get_position()]

	func fd_close() -> Wasip1Consts.Errno:
		return Wasip1Consts.Errno.ESUCCESS
