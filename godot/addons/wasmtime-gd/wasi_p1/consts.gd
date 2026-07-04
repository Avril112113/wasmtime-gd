@abstract
extends Object
class_name Wasip1Consts


# Based on https://gist.github.com/cjihrig/d7ca6d4ba541890f6b2eb7719fc0433d


## uint8_t __wasi_advice_t
enum Advice {
	DONTNEED = 0,
	NOREUSE = 1,
	NORMAL = 2,
	RANDOM = 3,
	SEQUENTIAL = 4,
	WILLNEED = 5,
}

# typedef struct __wasi_ciovec_s {
#  const void* buf;
#  size_t buf_len;
#} __wasi_ciovec_t;

## uint32_t __wasi_clockid_t
enum Clock {
	MONOTONIC = 0,
	PROCESS_CPUTIME_ID = 1,
	REALTIME = 2,
	THREAD_CPUTIME_ID = 3,
}

# uint64_t __wasi_device_t

## uint64_t __wasi_dircookie_t
enum DIRCOOKIE{
	START = 0,
}

## uint16_t __wasi_errno_t [br]
## Useful link: [url]https://man7.org/linux/man-pages/man3/errno.3.html[/url]
enum Errno {
	ESUCCESS = 0,
	E2BIG = 1,
	EACCES = 2,
	EADDRINUSE = 3,
	EADDRNOTAVAIL = 4,
	EAFNOSUPPORT = 5,
	EAGAIN = 6,
	EALREADY = 7,
	EBADF = 8,
	EBADMSG = 9,
	EBUSY = 10,
	ECANCELED = 11,
	ECHILD = 12,
	ECONNABORTED = 13,
	ECONNREFUSED = 14,
	ECONNRESET = 15,
	EDEADLK = 16,
	EDESTADDRREQ = 17,
	EDOM = 18,
	EDQUOT = 19,
	EEXIST = 20,
	EFAULT = 21,
	EFBIG = 22,
	EHOSTUNREACH = 23,
	EIDRM = 24,
	EILSEQ = 25,
	EINPROGRESS = 26,
	EINTR = 27,
	EINVAL = 28,
	EIO = 29,
	EISCONN = 30,
	EISDIR = 31,
	ELOOP = 32,
	EMFILE = 33,
	EMLINK = 34,
	EMSGSIZE = 35,
	EMULTIHOP = 36,
	ENAMETOOLONG = 37,
	ENETDOWN = 38,
	ENETRESET = 39,
	ENETUNREACH = 40,
	ENFILE = 41,
	ENOBUFS = 42,
	ENODEV = 43,
	ENOENT = 44,
	ENOEXEC = 45,
	ENOLCK = 46,
	ENOLINK = 47,
	ENOMEM = 48,
	ENOMSG = 49,
	ENOPROTOOPT = 50,
	ENOSPC = 51,
	ENOSYS = 52,
	ENOTCONN = 53,
	ENOTDIR = 54,
	ENOTEMPTY = 55,
	ENOTRECOVERABLE = 56,
	ENOTSOCK = 57,
	ENOTSUP = 58,
	ENOTTY = 59,
	ENXIO = 60,
	EOVERFLOW = 61,
	EOWNERDEAD = 62,
	EPERM = 63,
	EPIPE = 64,
	EPROTO = 65,
	EPROTONOSUPPORT = 66,
	EPROTOTYPE = 67,
	ERANGE = 68,
	EROFS = 69,
	ESPIPE = 70,
	ESRCH = 71,
	ESTALE = 72,
	ETIMEDOUT = 73,
	ETXTBSY = 74,
	EXDEV = 75,
	ENOTCAPABLE = 76,
}

## uint16_t __wasi_eventrwflags_t
const EVENT_FD_READWRITE_HANGUP = 1 << 0

## uint8_t __wasi_eventtype_t
enum EventType {
	CLOCK = 0,
	READ = 1,
	WRITE = 2,
}

# uint32_t __wasi_exitcode_t

# uint32_t __wasi_fd_t

## uint16_t __wasi_fdflags_t
enum FDFlags {
	APPEND = 1 << 0,
	DSYNC = 1 << 1,
	NONBLOCK = 1 << 2,
	RSYNC = 1 << 3,
	SYNC = 1 << 4,
}

# int64_t __wasi_filedelta_t

# uint64_t __wasi_filesize_t

## uint8_t __wasi_filetype_t
enum FileType {
	UNKNOWN = 0,
	BLOCK_DEVICE = 1,
	CHARACTER_DEVICE = 2,
	DIRECTORY = 3,
	REGULAR_FILE = 4,
	SOCKET_DGRAM = 5,
	SOCKET_STREAM = 6,
	SYMBOLIC_LINK = 7,
}

## uint16_t __wasi_fstflags_t
enum FileStat {
	SET_ATIM = 1 << 0,
	SET_ATIM_NOW = 1 << 1,
	SET_MTIM = 1 << 2,
	SET_MTIM_NOW = 1 << 3,
}

# uint64_t __wasi_inode_t

#typedef struct __wasi_iovec_s {
#  void* buf;
#  size_t buf_len;
#} __wasi_iovec_t;

# uint32_t __wasi_linkcount_t

# uint32_t __wasi_lookupflags_t
const LOOKUP_SYMLINK_FOLLOW = 1 << 0

## uint16_t __wasi_oflags_t
enum OFlags {
	CREAT = 1 << 0,
	DIRECTORY = 1 << 1,
	EXCL = 1 << 2,
	TRUNC = 1 << 3,
}

## uint16_t __wasi_riflags_t
enum RiFlags {
	PEEK = 1 << 0,
	WAITALL = 1 << 1,
}

## uint64_t __wasi_rights_t
enum Rights {
	FD_DATASYNC = 1 << 0,
	FD_READ = 1 << 1,
	FD_SEEK = 1 << 2,
	FD_FDSTAT_SET_FLAGS = 1 << 3,
	FD_SYNC = 1 << 4,
	FD_TELL = 1 << 5,
	FD_WRITE = 1 << 6,
	FD_ADVISE = 1 << 7,
	FD_ALLOCATE = 1 << 8,
	PATH_CREATE_DIRECTORY = 1 << 9,
	PATH_CREATE_FILE = 1 << 10,
	PATH_LINK_SOURCE = 1 << 11,
	PATH_LINK_TARGET = 1 << 12,
	PATH_OPEN = 1 << 13,
	FD_READDIR = 1 << 14,
	PATH_READLINK = 1 << 15,
	PATH_RENAME_SOURCE = 1 << 16,
	PATH_RENAME_TARGET = 1 << 17,
	PATH_FILESTAT_GET = 1 << 18,
	PATH_FILESTAT_SET_SIZE = 1 << 19,
	PATH_FILESTAT_SET_TIMES = 1 << 20,
	FD_FILESTAT_GET = 1 << 21,
	FD_FILESTAT_SET_SIZE = 1 << 22,
	FD_FILESTAT_SET_TIMES = 1 << 23,
	PATH_SYMLINK = 1 << 24,
	PATH_UNLINK_FILE = 1 << 25,
	PATH_REMOVE_DIRECTORY = 1 << 26,
	POLL_FD_READWRITE = 1 << 27,
	SOCK_SHUTDOWN = 1 << 28,
}

# uint16_t __wasi_roflags_t
const SOCK_RECV_DATA_TRUNCATED = 1 << 0

# uint8_t __wasi_sdflags_t
const SHUT_RD = 1 << 0
const SHUT_WR = 1 << 1

# uint16_t __wasi_siflags_t

## uint8_t __wasi_signal_t
enum Sig {
	ABRT = 0,
	ALRM = 1,
	BUS = 2,
	CHLD = 3,
	CONT = 4,
	FPE = 5,
	HUP = 6,
	ILL = 7,
	INT = 8,
	KILL = 9,
	PIPE = 10,
	QUIT = 11,
	SEGV = 12,
	STOP = 13,
	SYS = 14,
	TERM = 15,
	TRAP = 16,
	TSTP = 17,
	TTIN = 18,
	TTOU = 19,
	URG = 20,
	USR1 = 21,
	USR2 = 22,
	VTALRM = 23,
	XCPU = 24,
	XFSZ = 25,
}

## uint16_t __wasi_subclockflags_t
enum SubClockFlags {
	ABSTIME = 1 << 0,
}

# uint64_t __wasi_timestamp_t

# uint64_t __wasi_userdata_t

#typedef struct __wasi_subscription_s {
  #__wasi_userdata_t userdata;
  #__wasi_eventtype_t type;
  #union {
	#struct {
	  #__wasi_userdata_t identifier;
	  #__wasi_clockid_t clock_id;
	  #__wasi_timestamp_t timeout;
	  #__wasi_timestamp_t precision;
	  #__wasi_subclockflags_t flags;
	#} clock;
	#struct {
	  #__wasi_fd_t fd;
	#} fd_readwrite;
  #} u;
#} __wasi_subscription_t;
#
#typedef struct __wasi_dirent_s {
  #__wasi_dircookie_t d_next;
  #__wasi_inode_t d_ino;
  #uint32_t d_namlen;
  #__wasi_filetype_t d_type;
#} __wasi_dirent_t;
#
#typedef struct __wasi_fdstat_s {
  #__wasi_filetype_t fs_filetype;
  #__wasi_fdflags_t fs_flags;
  #__wasi_rights_t fs_rights_base;
  #__wasi_rights_t fs_rights_inheriting;
#} __wasi_fdstat_t;
#
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
#
#typedef struct __wasi_event_s {
  #__wasi_userdata_t userdata;
  #__wasi_errno_t error;
  #__wasi_eventtype_t type;
  #union {
	#struct {
	  #__wasi_filesize_t nbytes;
	  #__wasi_eventrwflags_t flags;
	#} fd_readwrite;
  #} u;
#} __wasi_event_t;

## uint8_t __wasi_whence_t
enum Whence {
	CUR = 0,
	END = 1,
	SET = 2,
}

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
