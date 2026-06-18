@abstract
extends Object
class_name Wasip1Consts


# Based on https://gist.github.com/cjihrig/d7ca6d4ba541890f6b2eb7719fc0433d


# uint8_t __wasi_advice_t
const ADVICE_DONTNEED = 0
const ADVICE_NOREUSE = 1
const ADVICE_NORMAL = 2
const ADVICE_RANDOM = 3
const ADVICE_SEQUENTIAL = 4
const ADVICE_WILLNEED = 5

# typedef struct __wasi_ciovec_s {
#  const void* buf;
#  size_t buf_len;
#} __wasi_ciovec_t;

# uint32_t __wasi_clockid_t
const CLOCK_MONOTONIC = 0
const CLOCK_PROCESS_CPUTIME_ID = 1
const CLOCK_REALTIME = 2
const CLOCK_THREAD_CPUTIME_ID = 3

# uint64_t __wasi_device_t

# uint64_t __wasi_dircookie_t
const DIRCOOKIE_START = 0

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

# uint16_t __wasi_eventrwflags_t
const EVENT_FD_READWRITE_HANGUP = 1 << 0

# uint8_t __wasi_eventtype_t
const EVENTTYPE_CLOCK = 0
const EVENTTYPE_FD_READ = 1
const EVENTTYPE_FD_WRITE = 2

# uint32_t __wasi_exitcode_t

# uint32_t __wasi_fd_t

# uint16_t __wasi_fdflags_t
const FDFLAG_APPEND = 1 << 0
const FDFLAG_DSYNC = 1 << 1
const FDFLAG_NONBLOCK = 1 << 2
const FDFLAG_RSYNC = 1 << 3
const FDFLAG_SYNC = 1 << 4

# int64_t __wasi_filedelta_t

# uint64_t __wasi_filesize_t

# uint8_t __wasi_filetype_t
const FILETYPE_UNKNOWN = 0
const FILETYPE_BLOCK_DEVICE = 1
const FILETYPE_CHARACTER_DEVICE = 2
const FILETYPE_DIRECTORY = 3
const FILETYPE_REGULAR_FILE = 4
const FILETYPE_SOCKET_DGRAM = 5
const FILETYPE_SOCKET_STREAM = 6
const FILETYPE_SYMBOLIC_LINK = 7

# uint16_t __wasi_fstflags_t
const FILESTAT_SET_ATIM = 1 << 0
const FILESTAT_SET_ATIM_NOW = 1 << 1
const FILESTAT_SET_MTIM = 1 << 2
const FILESTAT_SET_MTIM_NOW = 1 << 3

# uint64_t __wasi_inode_t

#typedef struct __wasi_iovec_s {
#  void* buf;
#  size_t buf_len;
#} __wasi_iovec_t;

# uint32_t __wasi_linkcount_t

# uint32_t __wasi_lookupflags_t
const LOOKUP_SYMLINK_FOLLOW = 1 << 0

# uint16_t __wasi_oflags_t
const O_CREAT = 1 << 0
const O_DIRECTORY = 1 << 1
const O_EXCL = 1 << 2
const O_TRUNC = 1 << 3

# uint16_t __wasi_riflags_t
const SOCK_RECV_PEEK = 1 << 0
const SOCK_RECV_WAITALL = 1 << 1

# uint64_t __wasi_rights_t
const RIGHT_FD_DATASYNC = 1 << 0
const RIGHT_FD_READ = 1 << 1
const RIGHT_FD_SEEK = 1 << 2
const RIGHT_FD_FDSTAT_SET_FLAGS = 1 << 3
const RIGHT_FD_SYNC = 1 << 4
const RIGHT_FD_TELL = 1 << 5
const RIGHT_FD_WRITE = 1 << 6
const RIGHT_FD_ADVISE = 1 << 7
const RIGHT_FD_ALLOCATE = 1 << 8
const RIGHT_PATH_CREATE_DIRECTORY = 1 << 9
const RIGHT_PATH_CREATE_FILE = 1 << 10
const RIGHT_PATH_LINK_SOURCE = 1 << 11
const RIGHT_PATH_LINK_TARGET = 1 << 12
const RIGHT_PATH_OPEN = 1 << 13
const RIGHT_FD_READDIR = 1 << 14
const RIGHT_PATH_READLINK = 1 << 15
const RIGHT_PATH_RENAME_SOURCE = 1 << 16
const RIGHT_PATH_RENAME_TARGET = 1 << 17
const RIGHT_PATH_FILESTAT_GET = 1 << 18
const RIGHT_PATH_FILESTAT_SET_SIZE = 1 << 19
const RIGHT_PATH_FILESTAT_SET_TIMES = 1 << 20
const RIGHT_FD_FILESTAT_GET = 1 << 21
const RIGHT_FD_FILESTAT_SET_SIZE = 1 << 22
const RIGHT_FD_FILESTAT_SET_TIMES = 1 << 23
const RIGHT_PATH_SYMLINK = 1 << 24
const RIGHT_PATH_UNLINK_FILE = 1 << 25
const RIGHT_PATH_REMOVE_DIRECTORY = 1 << 26
const RIGHT_POLL_FD_READWRITE = 1 << 27
const RIGHT_SOCK_SHUTDOWN = 1 << 28

# uint16_t __wasi_roflags_t
const SOCK_RECV_DATA_TRUNCATED = 1 << 0

# uint8_t __wasi_sdflags_t
const SHUT_RD = 1 << 0
const SHUT_WR = 1 << 1

# uint16_t __wasi_siflags_t

# uint8_t __wasi_signal_t
const SIGABRT = 0
const SIGALRM = 1
const SIGBUS = 2
const SIGCHLD = 3
const SIGCONT = 4
const SIGFPE = 5
const SIGHUP = 6
const SIGILL = 7
const SIGINT = 8
const SIGKILL = 9
const SIGPIPE = 10
const SIGQUIT = 11
const SIGSEGV = 12
const SIGSTOP = 13
const SIGSYS = 14
const SIGTERM = 15
const SIGTRAP = 16
const SIGTSTP = 17
const SIGTTIN = 18
const SIGTTOU = 19
const SIGURG = 20
const SIGUSR1 = 21
const SIGUSR2 = 22
const SIGVTALRM = 23
const SIGXCPU = 24
const SIGXFSZ = 25

# uint16_t __wasi_subclockflags_t
const SUBSCRIPTION_CLOCK_ABSTIME = 1 << 0

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

# uint8_t __wasi_whence_t
const WHENCE_CUR = 0
const WHENCE_END = 1
const WHENCE_SET = 2
