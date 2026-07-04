@abstract
extends Wasip1VfsEntryBase
class_name Wasip1VfsDirectoryBase


func _init(vfs: Wasip1Vfs) -> void:
	super._init(vfs)

func get_filetype() -> Wasip1Consts.FileType:
	return Wasip1Consts.FileType.DIRECTORY

func get_filesize() -> int:
	return 4096  # Based on a real FS value, which is roughly constant.

## [param path] is the full relative path.
## Returns [Wasip1VfsEntryBase] or [Wasip1Consts.Errno]
@abstract
func get_child(relative_path: String) -> Variant
