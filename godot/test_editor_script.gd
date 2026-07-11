@tool
extends EditorScript

# TODO:
# - Add other restrictions


func _run() -> void:
	print("~~~~~ SETUP")
	
	var clock := Wasip1ClockRealtime.new()
	var vfs := Wasip1Vfs.new(clock)
	
	var slash_dev := Wasip1VfsVirtualDirectory.new(vfs)
	vfs.vroot.add_child("dev", slash_dev)
	slash_dev.add_child("stdin", Wasip1VfsStreamFile.new(vfs).with_write("print('Hello World!')".to_utf8_buffer()))
	slash_dev.add_child("stdout", Wasip1VfsStreamFile.new(vfs))
	slash_dev.add_child("stderr", Wasip1VfsStreamFile.new(vfs))
	# Pre-opens
	assert(vfs.open_fd("/dev/stdin", 0) is Wasip1VfsFileDescriptor)
	assert(vfs.open_fd("/dev/stdout", 1) is Wasip1VfsFileDescriptor)
	assert(vfs.open_fd("/dev/stderr", 2) is Wasip1VfsFileDescriptor)
	assert(vfs.open_fd("/", 3) is Wasip1VfsFileDescriptor)
	
	#vfs.vroot.add_child("test.lua", Wasip1VfsVirtualFile.new(vfs).with_write("print('Hello Godot! (from test.lua)', require('foo'))".to_utf8_buffer()))
	#vfs.vroot.add_child("foo.lua", Wasip1VfsVirtualFile.new(vfs).with_write("print('Hello O_o (from foo.lua)')".to_utf8_buffer()))
	
	# Native lua.exe; 0.24s
	# LuaBoxes debug: 0.36s
	# LuaBoxes release: 0.36s
	#var entry_lua := "start = os.clock(); f = 1; for i=1,10000000 do f = f * f end; finish = os.clock(); print(finish-start)".to_utf8_buffer()
	# Native lua.exe; 0.043s
	# LuaBoxes debug: 0.274s
	# LuaBoxes release: 0.018s
	var entry_lua := "start = os.clock(); for i=1,1200 do print(\"Hi!\") end; finish = os.clock(); print(finish-start)".to_utf8_buffer()
	vfs.vroot.add_child("test.lua", Wasip1VfsVirtualFile.new(vfs).with_write(entry_lua))
	
	print("~~~~~ TEST IN")
	
	prints("/dev/stdin", vfs.get_entry("/dev/stdin"))
	prints("/dev/stdout", vfs.get_entry("/dev/stdout"))
	prints("/dev/stderr", vfs.get_entry("/dev/stderr"))
	
	var box := LuaBox.new(vfs)
	prints(box, box.is_setup)
	if not box.is_setup:
		return
	
	box._store.fuel = 10_000_000_000
	var starting_fuel := box._store.fuel
	
	print("~~~~~ main_cli()")
	
	box.wasi_environment.arguments = ["lua", "test.lua"]
	var start := Time.get_unix_time_from_system()
	print(box.main_cli())
	var finish := Time.get_unix_time_from_system()
	print("Took %ss and %s fuel" % [finish - start, starting_fuel - box._store.fuel])
	
	#print("~~~~~ new state")
	#
	#var state := box.new_state()
	#print(state)
	
	print("~~~~~ TEST OUT")
	
	var stdout: Wasip1VfsStreamFile = vfs.get_entry("/dev/stdout")
	var stderr: Wasip1VfsStreamFile = vfs.get_entry("/dev/stderr")
	prints("/dev/stdout", stdout.get_filesize())
	if stdout.get_filesize() > 0:
		print(stdout.read_all()[1].get_string_from_utf8())
	prints("/dev/stderr", stderr.get_filesize())
	if stderr.get_filesize() > 0:
		print(stderr.read_all()[1].get_string_from_utf8())
	
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
