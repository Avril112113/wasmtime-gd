extends RefCounted
class_name LuaBox


# LUA_REGISTRYINDEX	(-(INT_MAX/2 + 1000))
const RegistryIndex := -(2147483647/2 + 1000);

const RIdxGlobals := 2;
const RIdxMainThread := 3;


static var _config: WasmConfig = null
static var _engine: WasmEngine
static var _module: WasmModule
static var _dwarf: WasmDwarf = null


## This pattern is used to ensure these are set even if LuaBoxes is used in the editor.
static func __ensure_init(force_reload: bool = false) -> void:
	if _config == null or force_reload:
		var start := Time.get_ticks_msec()
		
		_config = WasmConfig.new() \
			.debug_info(true) \
			.wasm_exceptions(true) \
			.cranelift_opt_level("Speed") \
			.wasm_backtrace_details("Disable") \
			.consume_fuel(true)
		_engine = WasmEngine.new_with(_config)
		_module = WasmModule.new_from_file(_engine, "res://addons/lua-boxes-gd/lua.wasm")
		
		_dwarf = WasmDwarf.new_from(FileAccess.get_file_as_bytes("res://addons/lua-boxes-gd/lua.wasm"))
		
		#_module = WasmModule.deserialize(_engine, FileAccess.get_file_as_bytes("res://addons/lua-boxes-gd/lua.wasm.compiled"))
		
		#var f := FileAccess.open("res://addons/lua-boxes-gd/lua.wasm.compiled", FileAccess.WRITE)
		#f.store_buffer(_module.serialize())
		#f.close()
		
		var finish := Time.get_ticks_msec()
		print("__ensure_init() took %sms" % [(finish-start)])


var _store: WasmStore
var _linker: WasmLinker
var _instance: WasmInstance

var _exports: LuaWasmExports

var _function_table_indicies: Dictionary[Callable, int] = {}

var wasi_environment: Wasip1Environment
var wasi_vfs: Wasip1Vfs
var wasi_clock: Wasip1ClockRealtime:
	get: return wasi_vfs._clock

var is_setup := false


func _init(vfs: Wasip1Vfs) -> void:
	__ensure_init()
	
	_store = WasmStore.new_with(_engine)
	_store.fuel = 9_223_372_036_854_775_807
	_linker = WasmLinker.new_with(_engine)
	
	wasi_environment = Wasip1Environment.new()
	if not _linker.define_feature(_store, wasi_environment.define_feature): return
	
	if not _linker.define_feature(_store, vfs._clock.define_feature): return
	
	wasi_vfs = vfs
	if not _linker.define_feature(_store, wasi_vfs.define_feature): return
	
	_instance = _linker.instantiate(_store, _module)
	if _instance == null: return
	
	_exports = LuaWasmExports.new(_instance)
	
	if _instance.get_func("_initialize").call_wasm([]) is WasmError: return
	
	is_setup = true

## May return [code]-99999[/code] if there was a WASM error. This is a bug!
func main_cli() -> int:
	var result := _instance.get_func("main_cli").call_wasm([])
	if result is WasmError:
		return -99999
	return result[0]

## May return [WasmError] instead in the case of a wasm error.
func new_state() -> LuaState:
	var state_ptr := self._exports.luaL_newstate()
	if state_ptr is Array and len(state_ptr) == 1 and state_ptr[0] is int:
		return LuaState.new(self, state_ptr[0])
	elif state_ptr is WasmError:
		return state_ptr
	printerr("luaL_newstate() returned unexpect value %s" % [state_ptr])
	return null

func _get_or_add_indirect_function(callable: Callable) -> int:
	if callable in _function_table_indicies:
		return _function_table_indicies[callable]
	
	var idx := _exports.__indirect_function_table.size()
	_exports.__indirect_function_table.grow(1, WasmFunc.from_callable(_store, [WasmTypes.I32], [WasmTypes.I32], callable))
	_function_table_indicies[callable] = idx
	return idx
