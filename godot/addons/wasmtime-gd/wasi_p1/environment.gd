extends RefCounted
class_name Wasip1Environment


const MODULE_NAME = "wasi_snapshot_preview1"

## Setter will duplicate provided array and make it readonly.
var arguments: Array[String]:
	get:
		return arguments
	set(value):
		arguments = value.duplicate()
		arguments.make_read_only()
		
		_raw_arguments = PackedByteArray()
		_raw_arguments_offsets = PackedInt32Array()
		for arg in arguments:
			_raw_arguments_offsets.append(len(_raw_arguments))
			_raw_arguments.append_array(arg.to_utf8_buffer())
			_raw_arguments.append(0)

var _raw_arguments: PackedByteArray
var _raw_arguments_offsets: PackedInt32Array

## TODO: Make this a Dictionary instead.
## Setter will duplicate provided array and make it readonly.
var environ: Array[String]:
	get:
		return environ
	set(value):
		environ = value.duplicate()
		environ.make_read_only()
		
		_raw_environ = PackedByteArray()
		_raw_environ_offsets = PackedInt32Array()
		for arg in environ:
			_raw_environ_offsets.append(len(_raw_environ))
			_raw_environ.append_array(arg.to_utf8_buffer())
			_raw_environ.append(0)

var _raw_environ: PackedByteArray
var _raw_environ_offsets: PackedInt32Array


## Make sure to keep a reference to this RefCounted object!
## See https://github.com/godotengine/godot/issues/74990
## TODO: Check if we still need to worry about this, since we changed how [WasmUtils._define_func_name] works.
func _init() -> void:
	arguments = []
	environ = []


func define_feature(linker: WasmLinker, store: WasmStore) -> bool:
	return WasmUtils._define_many_func_name(self, linker, store, [
		"args_get",
		"args_sizes_get",
		"environ_get",
		"environ_sizes_get",
		"proc_exit",
	])

## https://wasix.org/docs/api-reference/wasi/args_get
var _wasm_args_get = [
	[WasmTypes.I32, WasmTypes.I32],
	[WasmTypes.I32],
	func _wasm_args_get(caller: WasmCaller, argv: int, argv_buf: int) -> int:
		var memory: WasmMemory = caller.get_export("memory")
		for i in range(len(arguments)):
			var offset = _raw_arguments_offsets[0]
			memory.write_i32(argv + i*4, argv_buf + offset)
		memory.write(argv_buf, _raw_arguments)
		return Wasip1Consts.Errno.ESUCCESS
]

## https://wasix.org/docs/api-reference/wasi/args_sizes_get
var _wasm_args_sizes_get = [
	[WasmTypes.I32, WasmTypes.I32],
	[WasmTypes.I32],
	func _wasm_args_sizes_get(caller: WasmCaller, argc: int, argv_buf_size: int) -> int:
		var memory: WasmMemory = caller.get_export("memory")
		memory.write_i32(argc, len(arguments))
		memory.write_i32(argv_buf_size, len(_raw_arguments))
		return Wasip1Consts.Errno.ESUCCESS
]

## https://wasix.org/docs/api-reference/wasi/environ_get
var _wasm_environ_get = [
	[WasmTypes.I32, WasmTypes.I32],
	[WasmTypes.I32],
	func _wasm_environ_get(caller: WasmCaller, argv: int, argv_buf: int) -> int:
		var memory: WasmMemory = caller.get_export("memory")
		for i in range(len(environ)):
			var offset = _raw_environ_offsets[0]
			memory.write_i32(argv + i*4, argv_buf + offset)
		memory.write(argv_buf, _raw_environ)
		return Wasip1Consts.Errno.ESUCCESS
]

## https://wasix.org/docs/api-reference/wasi/environ_sizes_get
var _wasm_environ_sizes_get = [
	[WasmTypes.I32, WasmTypes.I32],
	[WasmTypes.I32],
	func _wasm_environ_sizes_get(caller: WasmCaller, argc: int, argv_buf_size: int) -> int:
		var memory: WasmMemory = caller.get_export("memory")
		memory.write_i32(argc, len(environ))
		memory.write_i32(argv_buf_size, len(_raw_environ))
		return Wasip1Consts.Errno.ESUCCESS
]

var _wasm_proc_exit = [
	[WasmTypes.I32],
	[],
	func _wasm_environ_sizes_get(caller: WasmCaller, code: int) -> WasmError:
		return WasmErrorExit.new_error(code)
]
