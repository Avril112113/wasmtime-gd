@abstract
extends RefCounted
class_name Wasip1VfsHandle


var entry: Wasip1VfsEntryBase


func _init(entry: Wasip1VfsEntryBase) -> void:
	self.entry = entry


#  Directory Operations  #

## TODO: When actually imeplemented, the signature will change.
func fd_readdir() -> Wasip1Consts.Errno:
	return Wasip1Consts.Errno.ENOSYS

#  File Operations  #

## @virtual [br]
## Write result to [param bytes]
func fd_read(bytes: PackedByteArray, count: int) -> Wasip1Consts.Errno:
	return Wasip1Consts.Errno.ENOSYS

## @virtual [br]
## Consume from [param bytes]. Ensure to actually remove consumed bytes!
func fd_write(bytes: PackedByteArray) -> Wasip1Consts.Errno:
	return Wasip1Consts.Errno.ENOSYS

## @virtual [br]
## Returns [code][Wasip1Consts.Errno.XXX, POSITION][/code] [br]
## Default implementation [code]return self.fd_seek(0, Wasip1Consts.Whence.CUR)[/code]
func fd_tell() -> Array[int]:
	return self.fd_seek(0, Wasip1Consts.Whence.CUR)

## @virtual [br]
## Returns [code][lb]Wasip1Consts.Errno.XXX, POSITION[rb][/code]
func fd_seek(offset: int, whence: Wasip1Consts.Whence) -> Array[int]:
	return [Wasip1Consts.Errno.ENOSYS, 0]

## @virtual
func fd_close() -> Wasip1Consts.Errno:
	return Wasip1Consts.Errno.ENOSYS
