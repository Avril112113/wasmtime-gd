extends RefCounted
class_name LuaBox


# LUA_REGISTRYINDEX	(-(INT_MAX/2 + 1000))
const RegistryIndex := -1073742823

const RIdxGlobals := 2
const RIdxMainThread := 3

## Option for multiple returns in `lua_pcall` and `lua_call`
const MultRet := -1

enum LuaErr {
	OK = 0,
	YIELD = 1,
	ERRRUN = 2,
	ERRSYNTAX = 3,
	ERRMEM = 4,
	ERRERR = 5,
	## Extra error code for `luaL_loadfilex`
	ERRFILE = ERRERR + 1,
}

enum LuaType {
	NONE = -1,
	NIL = 0,
	BOOLEAN = 1,
	LIGHTUSERDATA = 2,
	NUMBER = 3,
	STRING = 4,
	TABLE = 5,
	FUNCTION = 6,
	USERDATA = 7,
	THREAD = 8,
}

enum LuaLibs {
	BASE = 1,
	PACKAGE = BASE << 1,
	COROUTINE = PACKAGE << 1,
	DEBUG = COROUTINE << 1,
	IO = DEBUG << 1,
	MATH = IO << 1,
	OS = MATH << 1,
	STRING = OS << 1,
	TABLE = STRING << 1,
	UTF8 = TABLE << 1,
}


static var _config: WasmConfig = null
static var _engine: WasmEngine
static var _module: WasmModule = null
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
		
		if FileAccess.file_exists("res://addons/lua-boxes-gd/lua.wasm.compiled"):
			_module = WasmModule.deserialize(_engine, FileAccess.get_file_as_bytes("res://addons/lua-boxes-gd/lua.wasm.compiled"))
		
		if _module == null:
			_module = WasmModule.new_from_file(_engine, "res://addons/lua-boxes-gd/lua.wasm")
			
			if Engine.is_editor_hint():
				var f := FileAccess.open("res://addons/lua-boxes-gd/lua.wasm.compiled", FileAccess.WRITE)
				f.store_buffer(_module.serialize())
				f.close()
		
		_dwarf = WasmDwarf.new_from(FileAccess.get_file_as_bytes("res://addons/lua-boxes-gd/lua.wasm"))
		
		var finish := Time.get_ticks_msec()
		print("__ensure_init() took %sms" % [(finish-start)])


var _store: WasmStore
var _linker: WasmLinker
var _instance: WasmInstance

var _exports: LuaWasmExports

var _function_table_indicies: Dictionary[Callable, int] = {}

var _raw_states: Dictionary[int, WeakRef] = {}
var _states: Dictionary[int, WeakRef] = {}

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

func get_main_state() -> LuaState:
	return self._get_state_from(self._exports.get_global_state()[0])

func new_state() -> LuaState:
	var state_ptr := self._exports.luaL_newstate()
	if state_ptr is Array and len(state_ptr) == 1 and state_ptr[0] is int:
		return self._get_state_from(state_ptr[0])
	elif state_ptr is WasmError:
		return state_ptr
	printerr("luaL_newstate() returned unexpect value %s" % [state_ptr])
	return null

func _get_state_raw(state_ptr: int) -> LuaStateRaw:
	if state_ptr == null:
		return null
	
	if state_ptr in self._raw_states:
		var weak := self._raw_states[state_ptr].get_ref()
		if weak != null:
			return weak
	
	var state_raw := LuaStateRaw.new(self, state_ptr)
	self._raw_states[state_ptr] = weakref(state_raw)
	return state_raw

func _get_state(state_raw: LuaStateRaw) -> LuaState:
	if state_raw._state_ptr in self._states:
		var weak := self._states[state_raw._state_ptr].get_ref()
		if weak != null:
			return weak
	
	var state := LuaState.new(state_raw)
	self._states[state_raw._state_ptr] = weakref(state)
	return state

func _get_state_from(state_ptr: int) -> LuaState:
	if state_ptr == null:
		return null
		
	return self._get_state(self._get_state_raw(state_ptr))

func _get_or_add_indirect_function(callable: Callable) -> int:
	if callable in _function_table_indicies:
		return _function_table_indicies[callable]
	
	var idx := _exports.__indirect_function_table.size()
	_exports.__indirect_function_table.grow(1, WasmFunc.from_callable(_store, [WasmTypes.I32], [WasmTypes.I32], callable))
	_function_table_indicies[callable] = idx
	return idx

func _malloc_string(s: String) -> int:
	var bytes := s.to_utf8_buffer()
	bytes.append(0)
	var ptr: int = self._exports._malloc(len(bytes))[0]
	self._exports.memory.write(ptr, bytes)
	return ptr

func _malloc_bytes(bytes: PackedByteArray) -> int:
	var ptr: int = self._exports._malloc(len(bytes))[0]
	self._exports.memory.write(ptr, bytes)
	return ptr

func _free(ptr: int) -> void:
	self._exports._free(ptr)

func _read_null_terminated_string(ptr: int, limit := 1024*1024*1024) -> String:
	var bytes := PackedByteArray()
	while len(bytes) <= limit:
		var byte := self._exports.memory.read(ptr + len(bytes), 1)[0]
		if byte == 0:
			return bytes.get_string_from_utf8()
		bytes.append(byte)
	return ""
