extends Wasip1VfsFileBase
class_name Wasip1VfsVirtualFile


var bytes := PackedByteArray()

var _access_time: int
var _modify_time: int
var _create_time: int


func _init(vfs: Wasip1Vfs) -> void:
	super._init(vfs)
	self._create_time = vfs._clock.now_nsec
	self._access_time = self._create_time
	self._modify_time = self._create_time

func with_write(bytes: PackedByteArray) -> Wasip1VfsVirtualFile:
	self.bytes.append_array(bytes)
	return self

func get_filesize() -> int:
	return len(bytes)

func get_access_time() -> int:
	return self._access_time

func get_modify_time() -> int:
	return self._modify_time

func get_create_time() -> int:
	return self._create_time

func open() -> FdHandle:
	return FdHandle.new(self)


class FdHandle:
	extends Wasip1VfsHandle
	
	var _entry: Wasip1VfsVirtualFile
	
	var _pos: int = 0
	
	func _init(entry: Wasip1VfsVirtualFile) -> void:
		super._init(entry)
		self._entry = entry
	
	func fd_read(bytes: PackedByteArray, count: int) -> Wasip1Consts.Errno:
		bytes.append_array(self._entry.bytes.slice(max(self._pos, 0), max(self._pos + count, 0)))
		self._pos = self._pos + len(bytes)
		return Wasip1Consts.Errno.ESUCCESS
	
	func fd_write(bytes: PackedByteArray) -> Wasip1Consts.Errno:
		if self._pos == len(bytes):
			self._entry.bytes.append_array(bytes)
		else:
			var right := self._entry.bytes.slice(self._pos)
			self._entry.bytes.resize(self._pos)
			self._entry.bytes.append_array(bytes)
			self._entry.bytes.append_array(right)
		
		self._pos += len(bytes)
		bytes.clear()
			
		return Wasip1Consts.Errno.ESUCCESS
	
	func fd_seek(offset: int, whence: Wasip1Consts.Whence) -> Array[int]:
		match whence:
			Wasip1Consts.Whence.CUR:
				self._pos = self._pos + offset
				return [Wasip1Consts.Errno.ESUCCESS, self._pos]
			Wasip1Consts.Whence.SET:
				self._pos = offset
				return [Wasip1Consts.Errno.ESUCCESS, self._pos]
			Wasip1Consts.Whence.END:
				self._pos = len(self._entry.bytes) + offset
				return [Wasip1Consts.Errno.ESUCCESS, self._pos]
		return [Wasip1Consts.Errno.EINVAL, self._pos]

	func fd_close() -> Wasip1Consts.Errno:
		return Wasip1Consts.Errno.ESUCCESS
