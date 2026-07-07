extends GutTest


var wasi_testsuite_cases:
	get:
		return [
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_getres-monotonic"],
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_getres-realtime"],
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_gettime-monotonic"],
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_gettime-realtime"],
			["res://tests/wasi-testsuite/tests/c/testsuite/fopen-with-access"],
			["res://tests/wasi-testsuite/tests/c/testsuite/fopen-with-no-access"],
			["res://tests/wasi-testsuite/tests/c/testsuite/fdopendir-with-access"],
			["res://tests/wasi-testsuite/tests/c/testsuite/lseek"],
			["res://tests/wasi-testsuite/tests/c/testsuite/pread-with-access"],
			["res://tests/wasi-testsuite/tests/c/testsuite/pwrite-with-access"],
			["res://tests/wasi-testsuite/tests/c/testsuite/stat-dev-ino"],
		]

func test_wasi_testsuite(params = use_parameters(wasi_testsuite_cases)):
	prints("~~~", params)
	var path: String = params[0]
	var wasm_path := path + ".wasm"
	var json_path := path.trim_suffix("_async") + ".json"
	assert_file_exists(wasm_path)
	
	var spec: Variant = JSON.parse_string(FileAccess.get_file_as_string(json_path)) if FileAccess.file_exists(json_path) else null
	
	var config := WasmConfig.new()
	var engine := WasmEngine.new_with(config)
	var module := WasmModule.new_from_file(engine, wasm_path)
	
	var store := WasmStore.new_with(engine)
	var linker := WasmLinker.new_with(engine)
	
	var wasi_env := Wasip1Environment.new()
	linker.define_feature(store, wasi_env.define_feature)
	
	var wasi_clock := Wasip1ClockRealtime.new()
	linker.define_feature(store, wasi_clock.define_feature)
	
	var wasi_vfs := Wasip1Vfs.new(wasi_clock)
	linker.define_feature(store, wasi_vfs.define_feature)
	var slash_dev := Wasip1VfsVirtualDirectory.new(wasi_vfs)
	wasi_vfs.vroot.add_child("dev", slash_dev)
	slash_dev.add_child("stdin", Wasip1VfsStreamFile.new(wasi_vfs))
	slash_dev.add_child("stdout", Wasip1VfsStreamFile.new(wasi_vfs))
	slash_dev.add_child("stderr", Wasip1VfsStreamFile.new(wasi_vfs))
	assert_is(wasi_vfs.open_fd("/dev/stdin", 0), Wasip1VfsFileDescriptor)
	assert_is(wasi_vfs.open_fd("/dev/stdout", 1), Wasip1VfsFileDescriptor)
	assert_is(wasi_vfs.open_fd("/dev/stderr", 2), Wasip1VfsFileDescriptor)
	assert_is(wasi_vfs.open_fd("/", 3), Wasip1VfsFileDescriptor)
	
	if spec != null:
		for field in spec.keys():
			var value: Variant = spec[field]
			if field == "dirs":
				for dir_name: String in value:
					wasi_vfs.vroot.add_child(dir_name, Wasip1VfsMappedDirectory.new(wasi_vfs, path.get_base_dir().path_join(dir_name)))
			else:
				push_error("test json spec is not yet supported. ", spec)
				return
	
	var instance := linker.instantiate(store, module)
	assert_is(instance, WasmInstance)
	if instance is not WasmInstance:
		return
	
	var start := instance.get_func("_start")
	assert_is(start, WasmFunc)
	
	var result: Variant = start.call_wasm([])
	assert_eq(result, null)
	if result is WasmError:
		result.print()
	
	var stdout_str: String = wasi_vfs.get_entry("/dev/stdout").read_all()[1].get_string_from_utf8()
	if len(stdout_str) > 0:
		print("stdout:")
		print(stdout_str)
	var stderr_str: String = wasi_vfs.get_entry("/dev/stderr").read_all()[1].get_string_from_utf8()
	if len(stderr_str) > 0:
		print("stderr:")
		print(stderr_str)
