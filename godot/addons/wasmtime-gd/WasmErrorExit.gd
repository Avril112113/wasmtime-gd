extends RefCounted
class_name WasmErrorExit


var exit_code: int

func _init(exit_code: int) -> void:
	self.exit_code = exit_code

static func new_error(exit_code: int) -> WasmError:
	return WasmError.new_from(WasmErrorExit.new(exit_code))
