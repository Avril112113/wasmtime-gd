extends RefCounted
class_name LuaState

var box: LuaBox
var _state_ptr: int


func _init(box: LuaBox, state_ptr: int) -> void:
	self.box = box
	self._state_ptr = state_ptr
