extends RefCounted
class_name Wasip1Vfs


const MODULE_NAME = "wasi_snapshot_preview1"


var _clock: Wasip1ClockRealtime
var _file_descriptors: Dictionary[int,Wasip1VfsFileDescriptor] = {}
var _next_fd := 1000
var _vroot: Wasip1VfsVirtualDirectory
var vroot: Wasip1VfsVirtualDirectory:
	get: return _vroot
var _epoch_nsec: int
var epoch_nsec: int:
	get: return _epoch_nsec


func _init(clock: Wasip1ClockRealtime) -> void:
	self._clock = clock
	self._vroot = Wasip1VfsVirtualDirectory.new(self)
	self._epoch_nsec = clock.now_nsec

## Returns [Wasip1VfsEntryBase] or [enum Wasip1Consts.Errno] in the case of failure.
func get_entry(path: String) -> Variant:
	var root: Wasip1VfsDirectoryBase
	if path.begins_with("/"):
		root = self.vroot
		path = path.trim_prefix("/")
	else:
		return Wasip1Consts.Errno.ENOSYS
	
	return root if path == "" else root.get_child(path)
	

## Returns [Wasip1VfsHandle] or [enum Wasip1Consts.Errno] in the case of failure.
func open_fd(path: String, fd: int = -1) -> Variant:
	var entry := self.get_entry(path)
	
	if entry is Wasip1VfsEntryBase:
		var handle: Variant = entry.open()
		var file_descriptor := Wasip1VfsFileDescriptor.new(handle, path)
		self._allocate_fd(file_descriptor, fd)
		return file_descriptor
	elif entry is Wasip1Consts.Errno:
		return entry
	else:
		push_error("vfs.get_file_entry() returned invalid result for path \"%s\"" % path)
	
	return Wasip1Consts.Errno.ENOSYS

func _allocate_fd(file_descriptor: Wasip1VfsFileDescriptor, fd: int = -1) -> int:
	if fd == -1:
		fd = _next_fd
		_next_fd += 1
	_file_descriptors[fd] = file_descriptor
	return fd

## Returns an open [Wasip1VfsFileDescriptor], or [code]null[/code] if the fd is not open.
func get_fd(fd: int) -> Wasip1VfsFileDescriptor:
	if fd in self._file_descriptors:
		return self._file_descriptors[fd]
	return null


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
	func _wasm_fd_advise(caller: WasmCaller, fd, offset, len, advice):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_allocate
var _wasm_fd_allocate = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_allocate(caller: WasmCaller, fd, offset, len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_close
var _wasm_fd_close = [
	["i32"],
	["i32"],
	func _wasm_fd_close(caller: WasmCaller, fd):
		if fd in self._file_descriptors:
			var descriptor := self._file_descriptors[fd]
			var errno := descriptor.handle.fd_close()
			self._file_descriptors.erase(fd)
			return errno
		return Wasip1Consts.Errno.EBADF
]

#https://wasix.org/docs/api-reference/wasi/fd_datasync
var _wasm_fd_datasync = [
	["i32"],
	["i32"],
	func _wasm_fd_datasync(caller: WasmCaller, fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_fdstat_get
var _wasm_fd_fdstat_get = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_fdstat_get(caller: WasmCaller, fd, buf_ptr):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		var descriptor := self._file_descriptors[fd]
		if descriptor._wasm_write_memory_filestat(buf_ptr, memory) == 0:
			return Wasip1Consts.Errno.EINVAL
		return Wasip1Consts.Errno.ESUCCESS
]

#https://wasix.org/docs/api-reference/wasi/fd_fdstat_set_flags
var _wasm_fd_fdstat_set_flags = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_fdstat_set_flags(caller: WasmCaller, fd, flags):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_fdstat_set_rights
var _wasm_fd_fdstat_set_rights = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_fdstat_set_rights(caller: WasmCaller, fd, fs_rights_base, fs_rights_inheriting):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_filestat_get
var _wasm_fd_filestat_get = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_filestat_get(caller: WasmCaller, fd, buf):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		if descriptor.handle.entry._wasm_write_memory_filestat(buf, memory) == 0:
			return Wasip1Consts.Errno.EINVAL
		return Wasip1Consts.Errno.ESUCCESS
]

#https://wasix.org/docs/api-reference/wasi/fd_filestat_set_size
var _wasm_fd_filestat_set_size = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_filestat_set_size(caller: WasmCaller, fd, st_size):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_filestat_set_times
var _wasm_fd_filestat_set_times = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_filestat_set_times(caller: WasmCaller, fd, st_atim, st_mtim, fst_flags):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_pread
var _wasm_fd_pread = [
	["i32", "i32", "i32", "i64", "i32"],
	["i32"],
	func _wasm_fd_pread(caller: WasmCaller, fd, iovs, iovs_len, offset, nread):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_prestat_get
var _wasm_fd_prestat_get = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_prestat_get(caller: WasmCaller, fd, buf):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		# FIXME: This get more than pre-opens, we should only allow obtaining pre-opens.
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		if descriptor._wasm_write_memory_prestat(buf, memory) == 0:
			return Wasip1Consts.Errno.EINVAL
		return Wasip1Consts.Errno.ESUCCESS
]

#https://wasix.org/docs/api-reference/wasi/fd_prestat_dir_name
var _wasm_fd_prestat_dir_name = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_prestat_dir_name(caller: WasmCaller, fd, path, path_len):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		if descriptor._wasm_write_memory_prestat_dir_name(path, path_len, memory) < 0:
			return Wasip1Consts.Errno.EINVAL
		return Wasip1Consts.Errno.ESUCCESS
]

#https://wasix.org/docs/api-reference/wasi/fd_pwrite
var _wasm_fd_pwrite = [
	["i32", "i32", "i32", "i64", "i32"],
	["i32"],
	func _wasm_fd_pwrite(caller: WasmCaller, fd, iovs, iovs_len, offset, nwritten):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_read
var _wasm_fd_read = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_read(caller: WasmCaller, fd, iovs, iovs_len, nread):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		var total_bytes := WasmUtils.read_iovs_total_buf_len(memory, iovs, iovs_len)
		var bytes := PackedByteArray()
		var errno := descriptor.handle.fd_read(bytes, total_bytes)
		if errno != Wasip1Consts.Errno.ESUCCESS:
			memory.write_u32(nread, 0)
			return errno
		var bytes_written := WasmUtils.write_iovs(memory, iovs, iovs_len, bytes)
		memory.write_u32(nread, bytes_written)
		return errno
]

#https://wasix.org/docs/api-reference/wasi/fd_readdir
var _wasm_fd_readdir = [
	["i32", "i32", "i32", "i64", "i32"],
	["i32"],
	func _wasm_fd_readdir(caller: WasmCaller, fd, buf, buf_len, cookie, bufused):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_renumber
var _wasm_fd_renumber = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_renumber(caller: WasmCaller, from_fd, to_fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_seek
var _wasm_fd_seek = [
	["i32", "i64", "i32", "i32"],
	["i32"],
	func _wasm_fd_seek(caller: WasmCaller, fd, offset, whence, newoffset):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		var result := descriptor.handle.fd_seek(offset, whence)
		memory.write_u64(newoffset, result[1])
		return result[0]
]

#https://wasix.org/docs/api-reference/wasi/fd_sync
var _wasm_fd_sync = [
	["i32"],
	["i32"],
	func _wasm_fd_sync(caller: WasmCaller, fd):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/fd_tell
var _wasm_fd_tell = [
	["i32", "i32"],
	["i32"],
	func _wasm_fd_tell(caller: WasmCaller, fd, offset):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		var result := descriptor.handle.fd_tell()
		memory.write_u64(offset, result[1])
		return result[0]
]

#https://wasix.org/docs/api-reference/wasi/fd_write
var _wasm_fd_write = [
	["i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_fd_write(caller: WasmCaller, fd, iovs, iovs_len, nwritten):
		if fd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var descriptor := self._file_descriptors[fd]
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		var bytes := WasmUtils.read_iovs(memory, iovs, iovs_len)
		var bytes_count := len(bytes)
		var errno := descriptor.handle.fd_write(bytes)
		# Writing the nwritten in the case where errno != OK is undefined. We write it anyway.
		memory.write_u32(nwritten, bytes_count - len(bytes))
		return errno
]

#https://wasix.org/docs/api-reference/wasi/path_create_directory
var _wasm_path_create_directory = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_path_create_directory(caller: WasmCaller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_filestat_get
var _wasm_path_filestat_get = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_filestat_get(caller: WasmCaller, fd, flags, path, path_len, buf):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_filestat_set_times
var _wasm_path_filestat_set_times = [
	["i32", "i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_filestat_set_times(caller: WasmCaller, fd, flags, path, path_len, st_atim, st_mtim, fst_flags):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_link
var _wasm_path_link = [
	["i32", "i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_link(caller: WasmCaller, old_fd, old_flags, old_path, old_path_len, new_fd, new_path, new_path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_open
var _wasm_path_open = [
	["i32", "i32", "i32", "i32", "i32", "i64", "i64", "i32", "i32"],
	["i32"],
	func _wasm_path_open(caller: WasmCaller, dirfd: int, dirflags: int, path_ptr: int, path_len: int, o_flags: Wasip1Consts.OFlags, fs_rights_base: Wasip1Consts.Rights, fs_rights_inheriting: Wasip1Consts.Rights, fs_flags: int, fd_ptr: int):
		if dirfd not in self._file_descriptors:
			return Wasip1Consts.Errno.EBADF
		var dir_descriptor := self._file_descriptors[dirfd]
		if dir_descriptor.handle.entry.get_filetype() != Wasip1Consts.FileType.DIRECTORY or dir_descriptor.handle.entry is not Wasip1VfsDirectoryBase:
			return Wasip1Consts.Errno.ENOTDIR
		var dir_entry := dir_descriptor.handle.entry as Wasip1VfsDirectoryBase
		
		var memory := caller.get_memory()
		if memory == null:
			return Wasip1Consts.Errno.ENOSYS
		
		var path := memory.read(path_ptr, path_len).get_string_from_utf8().simplify_path()
		var entry := dir_entry.get_child(path)
		if entry is Wasip1VfsEntryBase:
			var entry_file_type: Wasip1Consts.FileType = entry.get_filetype()
			if (o_flags & Wasip1Consts.OFlags.DIRECTORY) != 0 and (entry is not Wasip1VfsDirectoryBase or entry_file_type != Wasip1Consts.FileType.DIRECTORY):
				return Wasip1Consts.Errno.ENOTDIR
			
			if (o_flags & Wasip1Consts.OFlags.CREAT) != 0:
				return Wasip1Consts.Errno.ENOTSUP
			if (o_flags & Wasip1Consts.OFlags.EXCL) != 0:
				return Wasip1Consts.Errno.ENOTSUP
			if (o_flags & Wasip1Consts.OFlags.TRUNC) != 0:
				return Wasip1Consts.Errno.ENOTSUP
			
			var handle: Wasip1VfsHandle = entry.open()
			if handle == null:
				return Wasip1Consts.Errno.ENOENT
			var file_descriptor := Wasip1VfsFileDescriptor.new(handle, path)
			var fd := self._allocate_fd(file_descriptor)
			memory.write_u32(fd_ptr, fd)
			return Wasip1Consts.Errno.ESUCCESS
		elif entry is Wasip1Consts.Errno:
			return entry
		
		return WasmError.new_from("dir_entry.get_child() returned invalid value")
]

#https://wasix.org/docs/api-reference/wasi/path_readlink
var _wasm_path_readlink = [
	["i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_readlink(caller: WasmCaller, dir_fd, path, path_len, buf, buf_len, buf_used):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_remove_directory
var _wasm_path_remove_directory = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_path_remove_directory(caller: WasmCaller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_rename
var _wasm_path_rename = [
	["i32", "i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_rename(caller: WasmCaller, old_fd, old_path, old_path_len, new_fd, new_path, new_path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_symlink
var _wasm_path_symlink = [
	["i32", "i32", "i32", "i32", "i32"],
	["i32"],
	func _wasm_path_symlink(caller: WasmCaller, old_path, old_path_len, fd, new_path, new_path_len):
		return WasmError.new_from("Not implemented.")
]

#https://wasix.org/docs/api-reference/wasi/path_unlink_file
var _wasm_path_unlink_file = [
	["i32", "i32", "i32"],
	["i32"],
	func _wasm_path_unlink_file(caller: WasmCaller, fd, path, path_len):
		return WasmError.new_from("Not implemented.")
]
