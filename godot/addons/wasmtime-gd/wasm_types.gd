extends Object
class_name WasmTypes


## ValType
const I32: String = "i32"
## ValType
const I64: String = "i64"
## ValType
const F32: String = "f32"
## ValType
const F64: String = "f64"
## ValType
## [br]
const V128: String = "v128"

## HeapType
const EXTERN: String = "extern"
## HeapType
const NO_EXTERN: String = "no_extern"
## HeapType
const FUNC: String = "func"
## HeapType
const NO_FUNC: String = "no_func"
## HeapType
const ARRAY: String = "array"
## HeapType
const STRUCT: String = "struct"
## HeapType
const EXN: String = "exn"
## HeapType
const NO_EXN: String = "no_exn"
## HeapType
const CONT: String = "cont"
## HeapType
const NO_CONT: String = "no_cont"
## HeapType
const ANY: String = "any"
## HeapType
const NONE: String = "none"
## HeapType
const EQ: String = "eq"
## HeapType
## [br]
const I31: String = "i31"


## Used for [b]FuncType[/b] and [b]HeapType[/b] [br]
## Returns: ["func", arg_types, result_types] [br]
## Preferred to use this over manually creating the result, as it may change in the future.
static func funct(arg_types: Array[Variant], param_types: Array[Variant]):
	return [
		"func_type",
		arg_types,
		param_types
	]

## Used for [b]ValType[/b] [br]
## Returns: ["ref", is_nullable, heap_type] [br]
## Preferred to use this over manually creating the result, as it may change in the future.
static func ref(is_nullable: bool, heap_type: Variant):
	return [
		"ref_type",
		is_nullable,
		heap_type
	]


func _init() -> void:
	push_error("WasmTypes.new() is invalid!")
