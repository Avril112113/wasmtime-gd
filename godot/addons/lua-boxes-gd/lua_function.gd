extends LuaValueRef
class_name LuaFunction


func _init(state: LuaStateRaw, idx: int) -> void:
	super._init(state, idx)
	assert(self._type == LuaBox.LuaType.FUNCTION, "self._type == LuaBox.LuaType.FUNCTION")
