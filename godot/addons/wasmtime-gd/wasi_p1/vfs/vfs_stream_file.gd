extends Wasip1VfsFileBase
class_name Wasip1VfsStreamFile


var _buffer := StreamPeerBuffer.new()

var _access_time: int
var _modify_time: int
var _create_time: int


func _init(vfs: Wasip1Vfs) -> void:
	super._init(vfs)
	self._create_time = vfs._clock.now_nsec
	self._access_time = self._create_time
	self._modify_time = self._create_time

func with_write(bytes: PackedByteArray) -> Wasip1VfsStreamFile:
	self._buffer.put_data(bytes)
	return self

## Returns a chunk data with the received bytes, as an [Array] containing two elements: an Error constant and a [PackedByteArray]. bytes is the number of bytes to be received. If not enough bytes are available, the function will block until the desired amount is received.
func read_all() -> Array:
	self._buffer.seek(0)
	return self._buffer.get_data(self._buffer.get_size())

func get_filesize() -> int:
	return _buffer.get_size()

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
		if buffer.get_size() < count:
			return Wasip1Consts.Errno.EAGAIN
		buffer.seek(0)
		var result := buffer.get_data(count)
		#prints("read", result)
		bytes.append_array(result[1])
		if result[0] == Error.OK:
			return Wasip1Consts.Errno.ESUCCESS
		return Wasip1Consts.Errno.EIO
	
	func fd_write(bytes: PackedByteArray) -> Wasip1Consts.Errno:
		if len(bytes) <= 0:
			return Wasip1Consts.Errno.ESUCCESS
		var buffer := self._entry._buffer
		buffer.seek(buffer.get_size())
		buffer.put_data(bytes)
		bytes.clear()
		return Wasip1Consts.Errno.ESUCCESS
	
	func fd_seek(offset: int, whence: Wasip1Consts.Whence) -> Array[int]:
		return [Wasip1Consts.Errno.ESPIPE, 0]

	func fd_close() -> Wasip1Consts.Errno:
		return Wasip1Consts.Errno.ESUCCESS
