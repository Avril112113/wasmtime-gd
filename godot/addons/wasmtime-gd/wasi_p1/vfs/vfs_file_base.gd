@abstract
extends Wasip1VfsEntryBase
class_name Wasip1VfsFileBase


func _init(vfs: Wasip1Vfs) -> void:
	super._init(vfs)

func get_filetype() -> Wasip1Consts.FileType:
	return Wasip1Consts.FileType.REGULAR_FILE
