extends RefCounted
class_name LuaCFunction


# This is simply a convinient reference, all handling of the function in the indirect function table is handled by [LuaBox]


var box: LuaBox
var _fn_table_idx: int
## The callable that's called, not the key into the boxes dictionary!
var _callable: Callable

func _init(box: LuaBox, fn_table_idx: int, callable: Callable) -> void:
	self.box = box
	self._fn_table_idx = fn_table_idx
	self._callable = callable

func _push_closure(state: LuaStateRaw, upval_count: int = 0) -> WasmError:
	assert(self._fn_table_idx > 0)
	return state.lua_pushcclosure(self._fn_table_idx, upval_count)

## Free this LuaCFunction from the box if the underlying callable is no longer valid.
func free_if_invalid() -> bool:
	if _callable.is_valid():
		return false
	self.free_from_box()
	return true

func free_from_box() -> void:
	assert(self._fn_table_idx > 0)
	box._free_indirect_function(self)
	self._fn_table_idx = -1
