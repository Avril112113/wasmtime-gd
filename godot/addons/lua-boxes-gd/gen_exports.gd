@tool
extends EditorScript


func _run() -> void:
	LuaBox.__ensure_init(true)
	var exports := LuaBox._module.get_exports()
	var lines_defs := PackedStringArray()
	lines_defs.push_back("extends RefCounted")
	lines_defs.push_back("class_name LuaWasmExports")
	lines_defs.push_back("")
	
	var lines_init = PackedStringArray()
	lines_init.push_back("")
	lines_init.push_back("func _init(instance: WasmInstance):")
	
	for name: String in exports.keys():
		var wasm_type: Variant = exports[name]
		if name == "free" or name == "malloc" or name == "calloc":
			name = "_"+name
		lines_defs.push_back("# %s" % [wasm_type])
		lines_init.push_back("\t# %s" % [wasm_type])
		match wasm_type[0]:
			"memory":
				lines_defs.push_back("var %s: WasmMemory" % [name])
				lines_init.push_back("\tself.%s = instance.get_memory(\"%s\")" % [name, name])
			"func_type":
				var params := PackedStringArray()
				var args := PackedStringArray()
				for i in range(len(wasm_type[1])):
					var param_type = wasm_type[1][i]
					var godot_type = "Variant"
					match param_type:
						WasmTypes.I32, WasmTypes.I64:
							godot_type = "int"
						WasmTypes.F32, WasmTypes.F64:
							godot_type = "float"
						_:
							print("WARN: Func export '%s' has unhandled argument %s type '%s'" % [name, i, wasm_type])
					params.push_back("_arg%s: %s" % [i, godot_type])
					args.push_back("_arg%s" % [i])
				lines_defs.push_back("var __%s: WasmFunc" % [name])
				lines_defs.push_back("## Returns either an [Array] of results (typically 1 value) or [WasmError].")
				lines_defs.push_back("## For details, see [method WasmFunc.wasm_call]")
				lines_defs.push_back("func %s(%s) -> Variant:" % [name, ", ".join(params)])
				lines_defs.push_back("\treturn self.__%s.call_wasm_catch([%s])" % [name, ", ".join(args)])
				lines_init.push_back("\tself.__%s = instance.get_func(\"%s\")" % [name, name])
			_:
				lines_defs.push_back("# ???")
				lines_init.push_back("\t# ???")
				print("WARN: Export '%s' with unhandled type '%s'" % [name, wasm_type])
		lines_defs.push_back("")
		lines_init.push_back("\t")
	var f := FileAccess.open("res://addons/lua-boxes-gd/lua_wasm_exports.gd", FileAccess.WRITE)
	f.store_string("\n".join(lines_defs + lines_init))
	f.close()
