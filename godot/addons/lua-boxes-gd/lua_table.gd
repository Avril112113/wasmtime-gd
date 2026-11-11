extends LuaValueRef
class_name LuaTable


func _init(state: LuaStateRaw, idx: int) -> void:
	super._init(state, idx)
	assert(self._type == LuaBox.LuaType.TABLE, "self._type == LuaBox.LuaType.TABLE")
