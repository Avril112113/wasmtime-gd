extends RefCounted
class_name LuaCFunction


# This is simply a convinient reference, all handling of the function in the indirect function table is handled by [LuaBox]


var box: LuaBox
var _fn_table_idx: int

func _init(box: LuaBox, fn_table_idx: int) -> void:
	self.box = box
	self._fn_table_idx = fn_table_idx

func _push_closure(state: LuaStateRaw, upval_count: int = 0) -> WasmError:
	return state.lua_pushcclosure(self._fn_table_idx, upval_count)
