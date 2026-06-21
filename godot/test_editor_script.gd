@tool
extends EditorScript


func _run() -> void:
	var clock := Wasip1ClockRealtime.new()
	var vfs := Wasip1Vfs.new(clock)
	
	var box := LuaBox.new(vfs)
	prints(box, box.is_setup)
	if not box.is_setup:
		return
		
	print("~~~~~")
	
	print(box.main_cli())
	
	print("~~~~~")
	
	#var config := WasmConfig.new()
	#var engine := WasmEngine.new_with(config)
	#if engine == null:
		#return
	#
	#var module := WasmModule.new_from_file(engine, "res://test.wat")
	#if module == null:
		#return
	#
	#print("~ Imports ~")
	#var module_imports := module.get_imports()
	#for name in module_imports:
		#var import: Variant = module_imports[name]
		#print(name, " = ", import)
	#
	#print("~ Exports ~")
	#var module_exports := module.get_imports()
	#for name in module_exports:
		#var export: Variant = module_exports[name]
		#print(name, " = ", export)
	#
	#print()
	#
	#var store := WasmStore.new_with(engine)
	#var linker := WasmLinker.new_with(engine)
	#
	#var test_i32_import := WasmGlobal.new_i32(store, 404, true)
	#linker.define(store, "env", "test_i32_import", test_i32_import)
	#
	#linker.define(store, "env", "test_func", WasmFunc.from_callable(store, [WasmTypes.I32], [WasmTypes.I32], func(caller: WasmCaller, n: int) -> int:
		#prints("Hello from Godot from WASM!", n, caller)
		#return n + 1
	#))
#
	#var instance := linker.instantiate(store, module)
	#if instance == null:
		#return
	##print(instance)
	#
	#var test_func := instance.get_func("test_func")
	#prints(test_func.get_param_types(), test_func.get_result_types())
	#prints(test_func.call_wasm([1]))
	#
	#
	#var memory := instance.get_memory("memory")
	#print("%s minimum=%s maximum=%s is_64=%s is_shared=%s" % [memory, memory.minimum(), memory.maximum(), memory.is_64(), memory.is_shared()])
	#print("size=%s page_size=%s data_size=%s" % [memory.size(), memory.page_size(), memory.data_size()])
	#memory.grow(1)
	#print("size=%s page_size=%s data_size=%s" % [memory.size(), memory.page_size(), memory.data_size()])
	#print(memory.read(0, 16))
	#print(memory.write(0, range(0, 10)))
	#print(memory.read(0, 16))
