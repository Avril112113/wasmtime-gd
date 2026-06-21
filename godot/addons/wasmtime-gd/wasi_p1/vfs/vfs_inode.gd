extends RefCounted


var vfs: Wasip1Vfs
var device_num: int
var inode_num: int
var filetype: Wasip1Consts.FileType
var linkcount: int = 0  # Not implemented
var filesize: int = 0  # Not implemented
var access_time: int
var modify_time: int
var create_time: int

var impl  # TODO


func _init(vfs: Wasip1Vfs, device_num: int, inode_num: int, filetype: Wasip1Consts.FileType) -> void:
	self.vfs = vfs
	self.device_num = device_num
	self.inode_num = inode_num
	self.filetype = filetype
	self.access_time = vfs._clock.now_nsec
	self.modify_time = vfs._clock.now_nsec
	self.create_time = vfs._clock.now_nsec

func write_memory_filestat(offset: int, memory: WasmMemory) -> int:
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
	offset += memory.write_u64(offset, self.device_num, 8)
	offset += memory.write_u64(offset, self.inode_num, 8)
	offset += memory.write_u8(offset, self.filetype, 8)
	offset += memory.write_u64(offset, self.linkcount, 8)
	offset += memory.write_u64(offset, self.filesize, 8)
	offset += memory.write_u64(offset, self.access_time, 8)
	offset += memory.write_u64(offset, self.modify_time, 8)
	offset += memory.write_u64(offset, self.create_time, 8)
	return offset
