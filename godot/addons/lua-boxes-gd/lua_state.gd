extends RefCounted
class_name LuaState


## [img width=16]res://addons/wasmtime-gd/warn_icon.png[/img] WARN: Using [LuaStateRaw] will likely break the [LuaState] when used!
var _state: LuaStateRaw

var box: LuaBox:
	get: return _state.box

var lua_registry: LuaTable = null:
	get:
		if lua_registry == null:
			lua_registry = LuaTable.new(self._state, LuaBox.RegistryIndex)
		return lua_registry

var lua_globals: LuaTable = null:
	get:
		if lua_globals == null:
			# LuaBox.RegistryIndex is used as a known valid table, it's not actually used.
			lua_globals = LuaTable.new(self._state, LuaBox.RegistryIndex)
			lua_globals._pin_set(LuaBox.RIdxGlobals)
		return lua_globals

var main_state: LuaState = null:
	get:
		if main_state == null:
			self._state.lua_rawgeti(LuaBox.RegistryIndex, LuaBox.RIdxMainThread)
			main_state = self.box._get_state(self._state.lua_tothread(-1))
			self._state.lua_pop(1)
		return main_state


## Use [method LuaBox._get_state] or [method LuaBox._get_state_raw] instead
func _init(state: LuaStateRaw) -> void:
	self._state = state
	if state._state_ptr in state.box._states:
		push_warning("LuaState.new() is invalid, use LuaBox._get_state() or LuaBox._get_state_from() (multiple instances of LuaState now exist for this state)")

func _to_string() -> String:
	return "<LuaState 0x%x>" % [self._state._state_ptr]

func openlibs(load_: LuaBox.LuaLibs = ~0, preload_: LuaBox.LuaLibs = 0) -> WasmError:
	return self._state.luaL_openselectedlibs(load_, preload_)

## Loads Lua source text as a string. [br]
## Returns [LuaFunction] or [enum LuaBox.LuaErr]
func loadstring(s: String, name: String = "@loadstring") -> Variant:
	var result := self._state.luaL_loadbufferx(s.to_utf8_buffer(), name, "t")
	if result != LuaBox.LuaErr.OK:
		return result
	
	return LuaFunction.new(self._state, -1)

## Loads Lua source or binary form bytes. [br]
## Returns [LuaFunction] or [enum LuaBox.LuaErr]
func loadbytes(bytes: PackedByteArray, name: String = "@loadbytes") -> Variant:
	var result := self._state.luaL_loadbufferx(bytes, name)
	if result != LuaBox.LuaErr.OK:
		return result
	
	return LuaFunction.new(self._state, -1)

## Loads Lua source text as a string. [br]
## Returns [LuaFunction] or [enum LuaBox.LuaErr]
func loadfile(filename: String) -> Variant:
	var result := self._state.luaL_loadfilex(filename)
	if result != LuaBox.LuaErr.OK:
		return result
	
	return LuaFunction.new(self._state, -1)
