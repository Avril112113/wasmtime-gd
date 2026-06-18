@abstract
extends Object
class_name WasmUtils


## [param feature] should have a const [code]MODULE_NAME[/code]
## Looks for [code]_wasm_NAME[/code] with the following format; [[ARG_TYPE, ...], [RESULT_TYPE, ...], Callable]
static func _define_func_name(feature, linker: WasmLinker, store: WasmStore, name: String) -> bool:
	var module_name = feature.MODULE_NAME
	var info = feature["_wasm_" + name]
	var arg_types = info[0]
	var result_types = info[1]
	var callable = info[2]
	return linker.define(store, module_name, name, WasmFunc.from_callable(store, arg_types, result_types, callable))

## [param feature] should have a const [code]MODULE_NAME[/code]
## Attempts to define all and returns [code]false[/code] if any failed.
static func _define_many_func_name(feature, linker: WasmLinker, store: WasmStore, names: Array[String]) -> bool:
	var ok := true
	for name in names:
		ok = _define_func_name(feature, linker, store, name) and ok 
	return ok
