extends RefCounted
class_name LuaBox


static var _config: WasmConfig = null
static var _engine: WasmEngine
static var _module: WasmModule


## This pattern is used to ensure these are set even if LuaBoxes is used in the editor.
static func __ensure_init(force_reload: bool = false) -> void:
	if _config == null or force_reload:
		var start := Time.get_ticks_msec()
		
		_config = WasmConfig.new() \
			.wasm_exceptions(true) \
			.cranelift_opt_level("Speed") \
			.wasm_backtrace_details("Disable") \
			.consume_fuel(true)
		_engine = WasmEngine.new_with(_config)
		_module = WasmModule.new_from_file(_engine, "res://addons/lua-boxes-gd/lua.wasm")
		
		#_module = WasmModule.deserialize(_engine, FileAccess.get_file_as_bytes("res://addons/lua-boxes-gd/lua.wasm.compiled"))
		
		#var f := FileAccess.open("res://addons/lua-boxes-gd/lua.wasm.compiled", FileAccess.WRITE)
		#f.store_buffer(_module.serialize())
		#f.close()
		
		var finish := Time.get_ticks_msec()
		print("__ensure_init() took %sms" % [(finish-start)])


var _store: WasmStore
var _linker: WasmLinker
var _instance: WasmInstance

var wasi_environment: Wasip1Environment
var wasi_vfs: Wasip1Vfs
var wasi_clock: Wasip1ClockRealtime:
	get: return wasi_vfs._clock

var is_setup := false


func _init(vfs: Wasip1Vfs) -> void:
	__ensure_init()
	
	_store = WasmStore.new_with(_engine)
	_store.set_fuel(9_223_372_036_854_775_807)
	_linker = WasmLinker.new_with(_engine)
	
	wasi_environment = Wasip1Environment.new()
	if not _linker.define_feature(_store, wasi_environment.define_feature): return
	
	if not _linker.define_feature(_store, vfs._clock.define_feature): return
	
	wasi_vfs = vfs
	if not _linker.define_feature(_store, wasi_vfs.define_feature): return
	
	_instance = _linker.instantiate(_store, _module)
	if _instance == null: return
	
	if _instance.get_func("_initialize").call_wasm([]) is WasmError: return
	
	is_setup = true

## May return [code]-99999[/code] if there was a WASM error. This is a bug!
func main_cli() -> int:
	var result := _instance.get_func("main_cli").call_wasm([])
	if result is WasmError:
		return -99999
	return result[0]
