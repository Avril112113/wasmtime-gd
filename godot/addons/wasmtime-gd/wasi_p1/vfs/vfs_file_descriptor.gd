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
	offset += memory.write_u8(offset, self.handle.entry.get_filetype(), 8)
	offset += memory.write_u16(offset, self.flags, 8)
	offset += memory.write_u64(offset, self.rights, 8)
	offset += memory.write_u64(offset, self.rights_inheriting, 8)
	return offset

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
	offset += memory.write_u8(offset, 0 if self.handle.entry.get_filetype() == Wasip1Consts.FileType.DIRECTORY else 255, 4)
	offset += memory.write_u32(offset, self.path.length(), 4)
	return offset

func _wasm_write_memory_prestat_dir_name(path_ptr: int, path_len: int, memory: WasmMemory) -> int:
	return memory.write(path_ptr, self.path.substr(0, path_len).to_utf8_buffer(), 4)
