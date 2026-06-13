extends Object
class_name WasmTypes


const I32: String = "i32"
const I64: String = "i64"
const F32: String = "f32"
const F64: String = "f64"


## Returns: ["func", arg_types, result_types]
## 
## Preferred to use this over manually creating the result, as it may change in the future.
static func funct(arg_types: Array[Variant], param_types: Array[Variant]):
	return [
		"func",
		arg_types,
		param_types
	]

func _init() -> void:
	push_error("WasmTypes.new() is invalid!")
