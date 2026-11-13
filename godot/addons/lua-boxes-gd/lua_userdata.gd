extends LuaValueRef
class_name LuaUserdata


var _address: int


func _init(state: LuaStateRaw, idx: int, address := 0) -> void:
	super._init(state, idx)
	assert(self._type == LuaBox.LuaType.USERDATA, "self._type == LuaBox.LuaType.USERDATA")
	self._address = address

func _get_address() -> int:
	if self._address != 0:
		return self._address
	
	self._push(self._state)
	self._address = self._state.lua_touserdata(-1)
	self._state.lua_pop(1)
	return self._address
