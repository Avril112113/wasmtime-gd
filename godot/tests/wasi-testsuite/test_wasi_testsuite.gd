extends GutTest


var wasi_testsuite_cases:
	get:
		return [
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_getres-monotonic"],
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_getres-realtime"],
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_gettime-monotonic"],
			["res://tests/wasi-testsuite/tests/c/testsuite/clock_gettime-realtime"],
		]

func test_wasi_testsuite(params = use_parameters(wasi_testsuite_cases)):
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
	
	var instance := linker.instantiate(store, module)
	assert_is(instance, WasmInstance)
	
	var start := instance.get_func("_start")
	assert_is(start, WasmFunc)
	
	if spec != null:
		print(spec)
		wasi_env.arguments = spec["Args"]
	
	start.call_wasm([])
