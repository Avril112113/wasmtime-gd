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

var _function_table_indicies: Dictionary[Callable, LuaCFunction] = {}
var _function_table_spare_indicies: Array[int] = []
var _lua_error_cfunc: WasmFunc

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
	
	_lua_error_cfunc = WasmFunc.from_callable(_store, [WasmTypes.I32], [WasmTypes.I32], func(_caller: WasmCaller, state_ptr: int) -> Variant:
		var state := self._get_state_raw(state_ptr)
		state.lua_pushstring("Invalid")
		return state.lua_error()
	)
	
	is_setup = true

## May return [code]-99999[/code] if there was a WASM error. This is a bug!
func main_cli() -> int:
	var result := _exports.main_cli()
	if result is WasmError:
		if result.data is WasmErrorExit:
			return result.data.exit_code
		else:
			result.print()
		return -99999
	return result[0]

#region State

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

#endregion State

#region Function

func _get_or_add_indirect_function(callable_key: Callable, callable_called := Callable()) -> LuaCFunction:
	if callable_called == Callable():
		callable_called = callable_key
	
	if callable_key in _function_table_indicies:
		return _function_table_indicies[callable_key]
	
	var idx: int
	if len(self._function_table_spare_indicies) <= 0:
		idx = _exports.__indirect_function_table.size()
		_exports.__indirect_function_table.grow(1, WasmFunc.from_callable(_store, [WasmTypes.I32], [WasmTypes.I32], callable_called))
	else:
		idx = self._function_table_spare_indicies.pop_back()
		_exports.__indirect_function_table.set(1, WasmFunc.from_callable(_store, [WasmTypes.I32], [WasmTypes.I32], callable_called))
	var cfunc := LuaCFunction.new(self, idx, callable_called)
	_function_table_indicies[callable_key] = cfunc
	return cfunc

func _free_indirect_function(f: LuaCFunction) -> void:
	if self._function_table_indicies.erase(self._function_table_indicies.find_key(f)):
		self._function_table_spare_indicies.push_back(f._fn_table_idx)
		self._exports.__indirect_function_table.set(f._fn_table_idx, self._lua_error_cfunc)
	else:
		push_warning("Failed to erase ", f, " ", f._fn_table_idx, " from _function_table_indicies")

## WARN: These are not reference counted in the underlying WASM module. [br]
## Make sure to either re-use these or call [method LuaCFunction.free_from_box]. [br]
## No need to clean-up if the [LuaBox] is freed / never used again.
func lua_cfunction(callable: Callable) -> LuaCFunction:
	return self._get_or_add_indirect_function(
		callable,
		func(_caller: WasmCaller, state_ptr: int) -> Variant:
			var state := self._get_state_from(state_ptr)
			
			var args := [state]
			for i in range(state._state.lua_gettop()):
				var arg := state._state._to_variant(i + 1)
				if arg is WasmError:
					return arg
				args.push_back(arg)
			
			var result := callable.callv(args)
			if typeof(result) == TYPE_OBJECT and result is WasmError:
				return result
			if not typeof(result) == TYPE_ARRAY:
				push_error("lua_cfunction expected callable to return array of values or WasmError.")
				return 0
			
			var pushed := 0
			for value in result:
				var n := state._state._push_variant(value)
				if n == 0:
					return WasmError.new_from(value)
				pushed += n
			return pushed
	)

#endregion Function

#region Memory Utils

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

#endregion Memory Utils
