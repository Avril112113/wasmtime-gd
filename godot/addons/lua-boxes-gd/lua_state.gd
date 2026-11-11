extends RefCounted
class_name LuaState


## [img width=16]res://addons/wasmtime-gd/warn_icon.png[/img] WARN: Using [LuaStateRaw] will likely break the [LuaState] when used!
var _state: LuaStateRaw

var box: LuaBox:
	get: return _state.box

var lua_registry: LuaTable = null:
	get:
		if lua_registry == null:
			self._state.lua_pushvalue(LuaBox.RegistryIndex)
			lua_registry = LuaTable.new(self._state, -1)
			lua_registry._pin()
			self._state.lua_pop(1)
		return lua_registry


func _init(state: LuaStateRaw) -> void:
	self._state = state

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
