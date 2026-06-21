extends RefCounted
class_name Wasip1FileDescriptor


var inode: int
var flags: Wasip1Consts.FDFlags
var rights: Wasip1Consts.Rights
var rights_inheriting: Wasip1Consts.Rights
var impl  # TODO

var _vfs_weakref: WeakRef
var _vfs: Wasip1Vfs:
	get: return _vfs_weakref.get_ref()


func _init(vfs: Wasip1Vfs) -> void:
	self._vfs_weakref = weakref(vfs)

func write_memory_filestat(offset: int, memory: WasmMemory) -> int:
	#typedef struct __wasi_fdstat_s {
	  #__wasi_filetype_t fs_filetype;
	  #__wasi_fdflags_t fs_flags;
	  #__wasi_rights_t fs_rights_base;
	  #__wasi_rights_t fs_rights_inheriting;
	#} __wasi_fdstat_t;
	offset += memory.write_u8(offset, self._vfs._inodes[inode].filetype, 8)
	offset += memory.write_u16(offset, self.flags, 8)
	offset += memory.write_u64(offset, self.rights, 8)
	offset += memory.write_u64(offset, self.rights_inheriting, 8)
	return offset
