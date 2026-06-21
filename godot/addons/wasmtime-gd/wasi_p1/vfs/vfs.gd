extends RefCounted
class_name Wasip1Vfs


const VfsINode := preload("res://addons/wasmtime-gd/wasi_p1/vfs/vfs_inode.gd")

const MODULE_NAME = "wasi_snapshot_preview1"


var _clock: Wasip1ClockRealtime
var _inodes: Dictionary[int,VfsINode] = {}
var _file_descriptors: Dictionary[int,Wasip1FileDescriptor] = {}


func _init(clock: Wasip1ClockRealtime) -> void:
	self._clock = clock


func define_feature(linker: WasmLinker, store: WasmStore) -> bool:
	return WasmUtils._define_many_func_name(self, linker, store, [
		"fd_advise",
		"fd_allocate",
		"fd_close",
		"fd_datasync",
		"fd_fdstat_get",
		"fd_fdstat_set_flags",
		"fd_fdstat_set_rights",
		"fd_filestat_get",
		"fd_filestat_set_size",
		"fd_filestat_set_times",
		"fd_pread",
		"fd_prestat_get",
		"fd_prestat_dir_name",
		"fd_pwrite",
		"fd_read",
		"fd_readdir",
		"fd_renumber",
		"fd_seek",
		"fd_sync",
		"fd_tell",
		"fd_write",
		"path_create_directory",
		"path_filestat_get",
		"path_filestat_set_times",
		"path_link",
		"path_open",
		"path_readlink",
		"path_remove_directory",
		"path_rename",
		"path_symlink",
		"path_unlink_file",
	])


#https://wasix.org/docs/api-reference/wasi/fd_advise
var _wasm_fd_advise = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_advise(caller, fd, offset, len, advice):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_allocate
var _wasm_fd_allocate = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_allocate(caller, fd, offset, len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_close
var _wasm_fd_close = [
	["i32"],
	["i32"],
	func _wasm_fd_close(caller, fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_datasync
var _wasm_fd_datasync = [
	["i32"],
	["i32"],
	func _wasm_fd_datasync(caller, fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_fdstat_get
var _wasm_fd_fdstat_get = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_fdstat_get(caller, fd, buf_ptr):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_fdstat_set_flags
var _wasm_fd_fdstat_set_flags = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_fdstat_set_flags(caller, fd, flags):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_fdstat_set_rights
var _wasm_fd_fdstat_set_rights = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_fdstat_set_rights(caller, fd, fs_rights_base, fs_rights_inheriting):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_filestat_get
var _wasm_fd_filestat_get = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_filestat_get(caller, fd, buf):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_filestat_set_size
var _wasm_fd_filestat_set_size = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_filestat_set_size(caller, fd, st_size):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_filestat_set_times
var _wasm_fd_filestat_set_times = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_filestat_set_times(caller, fd, st_atim, st_mtim, fst_flags):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_pread
var _wasm_fd_pread = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_pread(caller, fd, iovs, iovs_len, offset, nread):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_prestat_get
var _wasm_fd_prestat_get = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_prestat_get(caller, fd, buf):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_prestat_dir_name
var _wasm_fd_prestat_dir_name = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_prestat_dir_name(caller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_pwrite
var _wasm_fd_pwrite = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_pwrite(caller, fd, iovs, iovs_len, offset, nwritten):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_read
var _wasm_fd_read = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_read(caller, fd, iovs, iovs_len, nread):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_readdir
var _wasm_fd_readdir = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_readdir(caller, fd, buf, buf_len, cookie, bufused):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_renumber
var _wasm_fd_renumber = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_renumber(caller, from_fd, to_fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_seek
var _wasm_fd_seek = [
	["i32", "i64", "i32", "i32"],
	["i32"],
	func _wasm_fd_seek(caller, fd, offset, whence, newoffset):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_sync
var _wasm_fd_sync = [
	["i32"],
	["i32"],
	func _wasm_fd_sync(caller, fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_tell
var _wasm_fd_tell = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_tell(caller, fd, offset):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_write
var _wasm_fd_write = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_write(caller, fd, iovs, iovs_len, nwritten):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_create_directory
var _wasm_path_create_directory = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_path_create_directory(caller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_filestat_get
var _wasm_path_filestat_get = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_filestat_get(caller, fd, flags, path, path_len, buf):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_filestat_set_times
var _wasm_path_filestat_set_times = [
	["i32", "i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_filestat_set_times(caller, fd, flags, path, path_len, st_atim, st_mtim, fst_flags):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_link
var _wasm_path_link = [
	["i32", "i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_link(caller, old_fd, old_flags, old_path, old_path_len, new_fd, new_path, new_path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_open
var _wasm_path_open = [
	["i32", "i32", "i32", "i32", "i32", "i64", "i64", "i32", "i32"],
	["i32"],
	func _wasm_path_open(caller, dirfd, dirflags, path, path_len, o_flags, fs_rights_base, fs_rights_inheriting, fs_flags, fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_readlink
var _wasm_path_readlink = [
	["i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_readlink(caller, dir_fd, path, path_len, buf, buf_len, buf_used):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_remove_directory
var _wasm_path_remove_directory = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_path_remove_directory(caller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_rename
var _wasm_path_rename = [
	["i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_rename(caller, old_fd, old_path, old_path_len, new_fd, new_path, new_path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_symlink
var _wasm_path_symlink = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_symlink(caller, old_path, old_path_len, fd, new_path, new_path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_unlink_file
var _wasm_path_unlink_file = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_path_unlink_file(caller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]
