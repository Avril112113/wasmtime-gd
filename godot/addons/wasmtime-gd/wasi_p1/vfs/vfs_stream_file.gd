extends Wasip1VfsFileBase
class_name Wasip1VfsStreamFile


var _buffer := PackedByteArray()

var _access_time: int
var _modify_time: int
var _create_time: int


func _init(vfs: Wasip1Vfs) -> void:
	super._init(vfs)
	self._create_time = vfs._clock.now_nsec
	self._access_time = self._create_time
	self._modify_time = self._create_time

func with_write(bytes: PackedByteArray) -> Wasip1VfsStreamFile:
	self._buffer.append_array(bytes)
	return self

func read_all() -> PackedByteArray:
	var data := self._buffer
	self._buffer = PackedByteArray()
	return data

func get_filesize() -> int:
	return len(_buffer)

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
	
	var _entry: Wasip1VfsStreamFile
	
	func _init(entry: Wasip1VfsStreamFile) -> void:
		super._init(entry)
		self._entry = entry
	
	func fd_read(bytes: PackedByteArray, count: int) -> Wasip1Consts.Errno:
		var buffer := self._entry._buffer
		if len(buffer) < count:
			count = len(buffer)
		bytes.append_array(buffer.slice(0, count))
		self._entry._buffer = buffer.slice(count)
		return Wasip1Consts.Errno.ESUCCESS
	
	func fd_write(bytes: PackedByteArray) -> Wasip1Consts.Errno:
		if len(bytes) <= 0:
			return Wasip1Consts.Errno.ESUCCESS
		var buffer := self._entry._buffer
		buffer.append_array(bytes)
		bytes.clear()
		return Wasip1Consts.Errno.ESUCCESS
	
	func fd_seek(offset: int, whence: Wasip1Consts.Whence) -> Array[int]:
		return [Wasip1Consts.Errno.ESPIPE, 0]

	func fd_close() -> Wasip1Consts.Errno:
		return Wasip1Consts.Errno.ESUCCESS
