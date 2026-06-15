extends Object
class_name WasmTypes


const I32: String = "i32"
const I64: String = "i64"
const F32: String = "f32"
const F64: String = "f64"
#const V128: String = "v128"

const EXTERN: String = "extern"
const EXTERN_NULLABLE: String = "extern?"
const NO_EXTERN: String = "no_extern"
const NO_EXTERN_NULLABLE: String = "no_extern?"
const FUNC: String = "func"
const FUNC_NULLABLE: String = "func?"
const NO_FUNC: String = "no_func"
const NO_FUNC_NULLABLE: String = "no_func?"
const ARRAY: String = "array"
const ARRAY_NULLABLE: String = "array?"
const STRUCT: String = "struct"
const STRUCT_NULLABLE: String = "struct?"
const EXN: String = "exn"
const EXN_NULLABLE: String = "exn?"
const NO_EXN: String = "no_exn"
const NO_EXN_NULLABLE: String = "no_exn?"
const CONT: String = "cont"
const CONT_NULLABLE: String = "cont?"
const NO_CONT: String = "no_cont"
const NO_CONT_NULLABLE: String = "no_cont?"
const ANY: String = "any"
const ANY_NULLABLE: String = "any?"
const NONE: String = "none"
const NONE_NULLABLE: String = "none?"
const EQ: String = "eq"
const EQ_NULLABLE: String = "eq?"
const I31: String = "i31"
const I31_NULLABLE: String = "i31?"


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
