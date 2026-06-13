@tool
extends EditorScript


func _run() -> void:
	var config := WasmConfig.new()
	var engine := WasmEngine.new_with(config)
	if engine == null:
		return
	
	var module := WasmModule.new_from_file(engine, "res://test.wat")
	if module == null:
		return
	
	var store := WasmStore.new_with(engine)
	var linker := WasmLinker.new_with(engine)
	
	var test_i32_import := WasmGlobal.new_i32(store, 404, true)
	linker.define(store, "env", "test_i32_import", test_i32_import)
	
	linker.define(store, "env", "test_func", WasmFunc.from_callable(store, [WasmTypes.I32], [WasmTypes.I32], func(n):
		prints("Hello from Godot from WASM!", n)
		return n + 1
	))

	var instance := linker.instantiate(store, module)
	if instance == null:
		return
	#print(instance)
	
	var test_func := instance.get_func(store, "test_func")
	prints(test_func.get_param_types(), test_func.get_result_types())
	prints(test_func.call_wasm([1]))
