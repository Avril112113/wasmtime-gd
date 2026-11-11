@abstract
extends RefCounted
class_name Wasip1VfsEntryBase


### Time in nsec since UNIX epoch.
#var access_time: int:
	#get: return access_time
	#set(value): access_time = max(access_time, value)

### Time in nsec since UNIX epoch.
#var modify_time: int:
	#get: return modify_time
	#set(value): modify_time = max(modify_time, value)

### Time in nsec since UNIX epoch.
#var create_time: int:
	#get: return create_time
	#set(value): create_time = max(create_time, value)

var _parent: WeakRef
## Possibly `null` if this is the root.
var parent: Wasip1VfsDirectoryBase:
	get: return _parent.get_ref()
	set(value):
		if (self._parent != null):
			push_error("Attempt to re-parent Vfs entry %s to %s" % [self, value])
		else:
			self._parent = weakref(value)

var _vfs_weakref: WeakRef
var vfs: Wasip1Vfs:
	get: return _vfs_weakref.get_ref()


func _init(vfs: Wasip1Vfs) -> void:
	self._vfs_weakref = weakref(vfs)

@abstract
func get_filetype() -> Wasip1Consts.FileType

@abstract
func get_filesize() -> int

## Time in nsec since UNIX epoch.
@abstract
func get_access_time() -> int

## Time in nsec since UNIX epoch.
@abstract
func get_modify_time() -> int

## Time in nsec since UNIX epoch.
@abstract
func get_create_time() -> int

@abstract
func open() -> Wasip1VfsHandle

func _wasm_write_memory_filestat(offset: int, memory: WasmMemory) -> int:
	#typedef struct __wasi_filestat_s {
	  #__wasi_device_t st_dev;
	  #__wasi_inode_t st_ino;
	  #__wasi_filetype_t st_filetype;
	  #__wasi_linkcount_t st_nlink;
	  #__wasi_filesize_t st_size;
	  #__wasi_timestamp_t st_atim;
	  #__wasi_timestamp_t st_mtim;
	  #__wasi_timestamp_t st_ctim;
	#} __wasi_filestat_t;
	offset += memory.write_u64(offset, 0)  # device_num, Not Implemented.
	offset += memory.write_u64(offset, 0)  # inode_num, Not Implemented.
	offset += memory.write_u8(offset, get_filetype())
	offset += memory.write_u64(offset, 0, 8)  # link_count, Not Implemented.
	offset += memory.write_u64(offset, get_filesize())
	offset += memory.write_u64(offset, get_access_time())
	offset += memory.write_u64(offset, get_modify_time())
	offset += memory.write_u64(offset, get_create_time())
	return offset
