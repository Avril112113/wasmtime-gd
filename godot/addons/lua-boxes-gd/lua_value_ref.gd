extends RefCounted
class_name LuaValueRef


var _state: LuaStateRaw
var _idx := -1
var _type: LuaBox.LuaType
var _ref_key: int
var _pointer: int

var box: LuaBox:
	get: return self._state.box


func _init(state: LuaStateRaw, idx: int) -> void:
	self._state = state
	self._idx = state.lua_absindex(idx)
	self._type = state.lua_type(self._idx)
	self._pointer = state.lua_topointer(self._idx)

func _to_string() -> String:
	if self._idx > 0:
		return "<Lua%s 0x%x @idx#%s>" % [LuaBox.LuaType.find_key(self._type).to_pascal_case(), self._pointer, self._idx]
	return "<Lua%s 0x%x @pin#%s>" % [LuaBox.LuaType.find_key(self._type).to_pascal_case(), self._pointer, self._ref_key]

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if self._idx <= 0:
			self._state.luaL_unref(LuaBox.RegistryIndex, self._ref_key)

func _pin() -> bool:
	var pushed := self._push(self._state)
	if pushed != 1:
		self._state.lua_pop(2 + pushed)
		return false
	# state: ..., value
	
	var ref_key = self._state.luaL_ref(LuaBox.RegistryIndex)
	# state: ...
	if typeof(ref_key) == TYPE_OBJECT:
		return false
	
	self._ref_key = ref_key
	self._idx = -1
	
	# state: ...
	return true

func _push(state: LuaStateRaw) -> int:
	assert(self._state != null, "self._state != null")
	
	# state: ...
	if _idx > 0:
		assert(self._state.lua_gettop() >= self._idx, "LuaValueRef BUG: state reference index %s is no longer valid! (top=%s)" % [self._idx, self._state.lua_gettop()])
		assert(self._state.lua_type(_idx) == self._type, "LuaValueRef BUG: state reference index %s changed type! (expected %s but got %s)" % [self._idx, LuaBox.LuaType.find_key(self._type), self._state.lua_type(_idx)])
		
		self._state.lua_pushvalue(_idx)
		# _state: ..., value
		if self._state._state_ptr != state._state_ptr:
			self._state.lua_xmove(state, 1)
			# _state: ...
		# state: ..., value
		return 1
	else:
		state.lua_rawgeti(LuaBox.RegistryIndex, self._ref_key)
		# state: ..., value
		if self._state.lua_type(_idx) != self._type:
			state.lua_pop(1)
			# state: ...
			assert(false, "LuaValueRef BUG: state reference index %s changed type! (expected %s but got %s)" % [self._idx, LuaBox.LuaType.find_key(self._type), self._state.lua_type(_idx)])
			return 0
		
		return 1
	
	printerr("_push failed")
	return 0

func get_type_name() -> String:
	return self._state.lua_typename(self._type)


## Returns [Array] on sucsess. [br]
## Returns [WasmError] on failure.
func lua_call(...args: Array[Variant]) -> Variant:
	var top := self._state.lua_gettop()
	
	self._push(self._state)
	
	var pushed := 0
	for arg in args:
		var n := self._state._push_variant(arg)
		if n == 0:
			self._state.lua_settop(top)
			return WasmError.new_from(arg)
		pushed += n
	
	var result := self._state.lua_call(pushed, LuaBox.MultRet)
	if result is WasmError:
		return result
	
	var results := []
	var results_count := self._state.lua_gettop() - top
	for i in range(results_count):
		results.push_back(self._state._to_variant(-(results_count - i)))
	
	self._state.lua_settop(top)
	
	return results

## Returns [Array] on sucsess. [br]
## Returns [Dictionary] [code]{"err": LuaBox.LuaErr, "value": Variant}[/code] on failure.
func lua_pcall(err_handler: LuaFunction = null, ...args: Array[Variant]) -> Variant:
	var top := self._state.lua_gettop()
	
	var errfunc_idx = 0
	if err_handler != null:
		err_handler._push(self._state)
		errfunc_idx = self._state.lua_absindex(-1)
	
	self._push(self._state)
	
	var pushed := 0
	for arg in args:
		var n := self._state._push_variant(arg)
		if n == 0:
			self._state.lua_settop(top)
			return WasmError.new_from(arg)
		pushed += n
	
	var result := self._state.lua_pcall(pushed, LuaBox.MultRet, errfunc_idx)
	if result != LuaBox.LuaErr.OK:
		var err_obj := self._state._to_variant(-1)
		if err_obj is LuaValueRef:
			err_obj._pin()
		self._state.lua_settop(top)
		return {"err": result, "value": err_obj}
	
	var results := []
	var results_count := self._state.lua_gettop() - top
	for i in range(results_count):
		results.push_back(self._state._to_variant(-(results_count - i)))
	
	self._state.lua_settop(top)
	
	return results

## Returns [WasmError] on error, otherwise [Variant] on sucsess.
func lua_get(key: Variant) -> Variant:
	# _state: ...
	assert(self._push(self._state) == 1)
	# _state: ..., self
	assert(self._state._push_variant(key) == 1)
	# _state: ..., self, key
	var result := self._state.lua_gettable(-2)
	if result is WasmError:
		return result
	# _state: ..., self, value
	var value := self._state._to_variant(-1)
	if value is LuaValueRef:
		value._pin()
	
	assert(not self._state.lua_pop(2) is WasmError)
	# _state: ...
	return value

## Returns [WasmError] on error, otherwise [code]null[/code] on sucsess.
func lua_set(key: Variant, value: Variant) -> WasmError:
	# _state: ...
	assert(self._push(self._state) == 1)
	# _state: ..., self
	assert(self._state._push_variant(key) == 1)
	# _state: ..., self, key
	assert(self._state._push_variant(value) == 1)
	# _state: ..., self, key, value
	var result := self._state.lua_settable(-3)
	if result is WasmError:
		return result
	# _state: ..., self
	assert(not self._state.lua_pop(1) is WasmError)
	# _state: ...
	return null

## Returns [WasmError] on error, otherwise [Variant] on sucsess.
func lua_len() -> Variant:
	# _state: ...
	self._push(self._state)
	# _state: ..., self
	var result := self._state.lua_len(-1)
	if result is WasmError:
		self._state.lua_pop(1)
		# _state: ...
		return result
	# _state: ..., self, value
	var value := self._state._to_variant(-1)
	if value is LuaValueRef:
		value._pin()
	self._state.lua_pop(2)
	return value

func lua_rawlen() -> int:
	# _state: ...
	self._push(self._state)
	# _state: ..., self
	var result := self._state.lua_rawlen(-1)
	self._state.lua_pop(1)
	return result
