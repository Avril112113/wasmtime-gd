extends RefCounted
class_name Wasip1VfsFileDescriptor


var flags: Wasip1Consts.FDFlags
var rights: Wasip1Consts.Rights  # Not Implemented by VFS, yet.
var rights_inheriting: Wasip1Consts.Rights  # Not Implemented by VFS, yet.

var handle: Wasip1VfsHandle
var path: String


func _init(handle: Wasip1VfsHandle, path: String) -> void:
	self.handle = handle
	self.path = path

func _wasm_write_memory_filestat(offset: int, memory: WasmMemory) -> int:
	#typedef struct __wasi_fdstat_s {
	  #__wasi_filetype_t fs_filetype;
	  #__wasi_fdflags_t fs_flags;
	  #__wasi_rights_t fs_rights_base;
	  #__wasi_rights_t fs_rights_inheriting;
	#} __wasi_fdstat_t;
	if memory.write_u8(offset + 0, self.handle.entry.get_filetype()) == 0: return 0
	if memory.write_u16(offset + 2, self.flags) == 0: return 0
	if memory.write_u64(offset + 8, self.rights) == 0: return 0
	if memory.write_u64(offset + 16, self.rights_inheriting) == 0: return 0
	return 24

func _wasm_write_memory_prestat(offset: int, memory: WasmMemory) -> int:
	#typedef struct __wasi_prestat_dir_t {
	  #/**
	   #* The length of the directory name for use with `fd_prestat_dir_name`.
	   #*/
	  #__wasi_size_t pr_name_len;
	#
	#} __wasi_prestat_dir_t;
	#typedef union __wasi_prestat_u_t {
	  #__wasi_prestat_dir_t dir;
	#} __wasi_prestat_u_t;
	#typedef struct __wasi_prestat_t {
	  #uint8_t tag;
	  #__wasi_prestat_u_t u;
	#} __wasi_prestat_t;
	var preopen_type
	if self.handle.entry.get_filetype() == Wasip1Consts.FileType.DIRECTORY:
		preopen_type = 0
	else:
		return 0
	if memory.write_u8(offset + 0, preopen_type) == 0: return 0
	if memory.write_u32(offset + 4, len(self.path.to_utf8_buffer())): return 0
	return 8

func _wasm_write_memory_prestat_dir_name(path_ptr: int, path_len: int, memory: WasmMemory) -> int:
	var bytes := self.path.to_utf8_buffer()
	if len(bytes) > path_len:
		return 0
	return memory.write(path_ptr, bytes)
