extends RefCounted
class_name LuaWasmExports

# ["memory", false, false, 16, 2]
var memory: WasmMemory

# ["global_type", "var", "i32"]
# ???

# ["func_type", [], []]
var ___initialize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func _initialize() -> Variant:
	return self.___initialize.call_wasm_catch([])

# ["table", ["ref_type", true, "func"], false, 202]
var __indirect_function_table: WasmTable

# ["tag_type", ["func_type", ["i32"], []]]
# ???

# ["func_type", [], ["i32"]]
var __luaL_newstate: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_newstate() -> Variant:
	return self.__luaL_newstate.call_wasm_catch([])

# ["func_type", [], ["i32"]]
var __get_global_state: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func get_global_state() -> Variant:
	return self.__get_global_state.call_wasm_catch([])

# ["func_type", ["i32"], ["i32"]]
var ___malloc: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func _malloc(size: int) -> Variant:
	return self.___malloc.call_wasm_catch([size])

# ["func_type", ["i32"], []]
var ___free: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func _free(ptr: int) -> Variant:
	return self.___free.call_wasm_catch([ptr])

# ["func_type", [], ["i32"]]
var __main_cli: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func main_cli() -> Variant:
	return self.__main_cli.call_wasm_catch([])

# ["func_type", ["i32"], ["i32"]]
var __lua_gettop: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_gettop(L: int) -> Variant:
	return self.__lua_gettop.call_wasm_catch([L])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_gc: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_gc(L: int, what: int, va_list_argp: int) -> Variant:
	return self.__lua_gc.call_wasm_catch([L, what, va_list_argp])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_pushcclosure: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushcclosure(L: int, fn: int, n: int) -> Variant:
	return self.__lua_pushcclosure.call_wasm_catch([L, fn, n])

# ["func_type", ["i32", "i64"], []]
var __lua_pushinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushinteger(L: int, n: int) -> Variant:
	return self.__lua_pushinteger.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32"], []]
var __lua_pushlightuserdata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushlightuserdata(L: int, p: int) -> Variant:
	return self.__lua_pushlightuserdata.call_wasm_catch([L, p])

# ["func_type", ["i32", "i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __lua_pcallk: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pcallk(L: int, nargs: int, nresults: int, errfunc: int, ctx: int, k: int) -> Variant:
	return self.__lua_pcallk.call_wasm_catch([L, nargs, nresults, errfunc, ctx, k])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_toboolean: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_toboolean(L: int, idx: int) -> Variant:
	return self.__lua_toboolean.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_tolstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_tolstring(L: int, idx: int, len: int) -> Variant:
	return self.__lua_tolstring.call_wasm_catch([L, idx, len])

# ["func_type", ["i32", "i32"], []]
var __lua_settop: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_settop(L: int, idx: int) -> Variant:
	return self.__lua_settop.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i64"]]
var __lua_tointegerx: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_tointegerx(L: int, idx: int, pisnum: int) -> Variant:
	return self.__lua_tointegerx.call_wasm_catch([L, idx, pisnum])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_touserdata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_touserdata(L: int, idx: int) -> Variant:
	return self.__lua_touserdata.call_wasm_catch([L, idx])

# ["func_type", ["i32", "f64", "i32"], []]
var __luaL_checkversion_: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checkversion_(L: int, ver: float, sz: int) -> Variant:
	return self.__luaL_checkversion_.call_wasm_catch([L, ver, sz])

# ["func_type", ["i32", "i32"], []]
var __lua_pushboolean: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushboolean(L: int, b: int) -> Variant:
	return self.__lua_pushboolean.call_wasm_catch([L, b])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_setfield: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setfield(L: int, idx: int, k: int) -> Variant:
	return self.__lua_setfield.call_wasm_catch([L, idx, k])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_openselectedlibs: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_openselectedlibs(L: int, load_: int, preload_: int) -> Variant:
	return self.__luaL_openselectedlibs.call_wasm_catch([L, load_, preload_])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_createtable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_createtable(L: int, narray: int, nrec: int) -> Variant:
	return self.__lua_createtable.call_wasm_catch([L, narray, nrec])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_pushstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushstring(L: int, s: int) -> Variant:
	return self.__lua_pushstring.call_wasm_catch([L, s])

# ["func_type", ["i32", "i32", "i64"], []]
var __lua_rawseti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawseti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_rawseti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], []]
var __lua_setglobal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setglobal(L: int, name: int) -> Variant:
	return self.__lua_setglobal.call_wasm_catch([L, name])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_loadfilex: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_loadfilex(L: int, filename: int, mode: int) -> Variant:
	return self.__luaL_loadfilex.call_wasm_catch([L, filename, mode])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_loadbufferx: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_loadbufferx(L: int, buff: int, size: int, name: int, mode: int) -> Variant:
	return self.__luaL_loadbufferx.call_wasm_catch([L, buff, size, name, mode])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_warning: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_warning(L: int, msg: int, tocont: int) -> Variant:
	return self.__lua_warning.call_wasm_catch([L, msg, tocont])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_getglobal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getglobal(L: int, name: int) -> Variant:
	return self.__lua_getglobal.call_wasm_catch([L, name])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_rotate: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rotate(L: int, idx: int, n: int) -> Variant:
	return self.__lua_rotate.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_error: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_error(L: int, fmt: int, va_list_argp: int) -> Variant:
	return self.__luaL_error.call_wasm_catch([L, fmt, va_list_argp])

# ["func_type", ["i32", "i32"], ["i64"]]
var __luaL_len: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_len(L: int, idx: int) -> Variant:
	return self.__luaL_len.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_checkstack: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checkstack(L: int, space: int, msg: int) -> Variant:
	return self.__luaL_checkstack.call_wasm_catch([L, space, msg])

# ["func_type", ["i32", "i32", "i64"], ["i32"]]
var __lua_rawgeti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawgeti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_rawgeti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_tolstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_tolstring(L: int, idx: int, len: int) -> Variant:
	return self.__luaL_tolstring.call_wasm_catch([L, idx, len])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_pushlstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushlstring(L: int, s: int, len: int) -> Variant:
	return self.__lua_pushlstring.call_wasm_catch([L, s, len])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_pushfstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushfstring(L: int, fmt: int, va_list_argp: int) -> Variant:
	return self.__lua_pushfstring.call_wasm_catch([L, fmt, va_list_argp])

# ["func_type", ["i32", "i32"], []]
var __lua_concat: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_concat(L: int, n: int) -> Variant:
	return self.__lua_concat.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_callmeta: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_callmeta(L: int, obj: int, event: int) -> Variant:
	return self.__luaL_callmeta.call_wasm_catch([L, obj, event])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_type: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_type(L: int, idx: int) -> Variant:
	return self.__lua_type.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_typename: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_typename(L: int, t: int) -> Variant:
	return self.__lua_typename.call_wasm_catch([L, t])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __luaL_traceback: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_traceback(L: int, L1: int, msg: int, level: int) -> Variant:
	return self.__luaL_traceback.call_wasm_catch([L, L1, msg, level])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __lua_sethook: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_sethook(L: int, func_: int, mask: int, count: int) -> Variant:
	return self.__lua_sethook.call_wasm_catch([L, func_, mask, count])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_checkstack: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_checkstack(L: int, n: int) -> Variant:
	return self.__lua_checkstack.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_xmove: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_xmove(from: int, to: int, n: int) -> Variant:
	return self.__lua_xmove.call_wasm_catch([from, to, n])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_atpanic: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_atpanic(L: int, panicf: int) -> Variant:
	return self.__lua_atpanic.call_wasm_catch([L, panicf])

# ["func_type", ["i32"], ["f64"]]
var __lua_version: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_version(L: int) -> Variant:
	return self.__lua_version.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_absindex: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_absindex(L: int, idx: int) -> Variant:
	return self.__lua_absindex.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], []]
var __lua_closeslot: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_closeslot(L: int, idx: int) -> Variant:
	return self.__lua_closeslot.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_copy: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_copy(L: int, fromidx: int, toidx: int) -> Variant:
	return self.__lua_copy.call_wasm_catch([L, fromidx, toidx])

# ["func_type", ["i32", "i32"], []]
var __lua_pushvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushvalue(L: int, idx: int) -> Variant:
	return self.__lua_pushvalue.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_iscfunction: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_iscfunction(L: int, idx: int) -> Variant:
	return self.__lua_iscfunction.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_isinteger(L: int, idx: int) -> Variant:
	return self.__lua_isinteger.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isnumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_isnumber(L: int, idx: int) -> Variant:
	return self.__lua_isnumber.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_isstring(L: int, idx: int) -> Variant:
	return self.__lua_isstring.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isuserdata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_isuserdata(L: int, idx: int) -> Variant:
	return self.__lua_isuserdata.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_rawequal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawequal(L: int, index1: int, index2: int) -> Variant:
	return self.__lua_rawequal.call_wasm_catch([L, index1, index2])

# ["func_type", ["i32", "i32"], []]
var __lua_arith: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_arith(L: int, op: int) -> Variant:
	return self.__lua_arith.call_wasm_catch([L, op])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_compare: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_compare(L: int, index1: int, index2: int, op: int) -> Variant:
	return self.__lua_compare.call_wasm_catch([L, index1, index2, op])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_numbertocstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_numbertocstring(L: int, idx: int, buff: int) -> Variant:
	return self.__lua_numbertocstring.call_wasm_catch([L, idx, buff])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_stringtonumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_stringtonumber(L: int, s: int) -> Variant:
	return self.__lua_stringtonumber.call_wasm_catch([L, s])

# ["func_type", ["i32", "i32", "i32"], ["f64"]]
var __lua_tonumberx: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_tonumberx(L: int, idx: int, pisnum: int) -> Variant:
	return self.__lua_tonumberx.call_wasm_catch([L, idx, pisnum])

# ["func_type", ["i32", "i32"], ["i64"]]
var __lua_rawlen: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawlen(L: int, idx: int) -> Variant:
	return self.__lua_rawlen.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_tocfunction: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_tocfunction(L: int, idx: int) -> Variant:
	return self.__lua_tocfunction.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_tothread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_tothread(L: int, idx: int) -> Variant:
	return self.__lua_tothread.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_topointer: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_topointer(L: int, idx: int) -> Variant:
	return self.__lua_topointer.call_wasm_catch([L, idx])

# ["func_type", ["i32"], []]
var __lua_pushnil: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushnil(L: int) -> Variant:
	return self.__lua_pushnil.call_wasm_catch([L])

# ["func_type", ["i32", "f64"], []]
var __lua_pushnumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushnumber(L: int, n: float) -> Variant:
	return self.__lua_pushnumber.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __lua_pushexternalstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushexternalstring(L: int, s: int, len: int, falloc: int, ud: int) -> Variant:
	return self.__lua_pushexternalstring.call_wasm_catch([L, s, len, falloc, ud])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_pushvfstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushvfstring(L: int, fmt: int, argp: int) -> Variant:
	return self.__lua_pushvfstring.call_wasm_catch([L, fmt, argp])

# ["func_type", ["i32"], ["i32"]]
var __lua_pushthread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_pushthread(L: int) -> Variant:
	return self.__lua_pushthread.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_gettable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_gettable(L: int, idx: int) -> Variant:
	return self.__lua_gettable.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getfield: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getfield(L: int, idx: int, k: int) -> Variant:
	return self.__lua_getfield.call_wasm_catch([L, idx, k])

# ["func_type", ["i32", "i32", "i64"], ["i32"]]
var __lua_geti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_geti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_geti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_rawget: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawget(L: int, idx: int) -> Variant:
	return self.__lua_rawget.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_rawgetp: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawgetp(L: int, idx: int, p: int) -> Variant:
	return self.__lua_rawgetp.call_wasm_catch([L, idx, p])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_getmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getmetatable(L: int, objindex: int) -> Variant:
	return self.__lua_getmetatable.call_wasm_catch([L, objindex])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getiuservalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getiuservalue(L: int, idx: int, n: int) -> Variant:
	return self.__lua_getiuservalue.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], []]
var __lua_settable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_settable(L: int, idx: int) -> Variant:
	return self.__lua_settable.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i64"], []]
var __lua_seti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_seti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_seti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], []]
var __lua_rawset: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawset(L: int, idx: int) -> Variant:
	return self.__lua_rawset.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_rawsetp: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_rawsetp(L: int, idx: int, p: int) -> Variant:
	return self.__lua_rawsetp.call_wasm_catch([L, idx, p])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_setmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setmetatable(L: int, objindex: int) -> Variant:
	return self.__lua_setmetatable.call_wasm_catch([L, objindex])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_setiuservalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setiuservalue(L: int, idx: int, n: int) -> Variant:
	return self.__lua_setiuservalue.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], []]
var __lua_callk: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_callk(L: int, nargs: int, nresults: int, ctx: int, k: int) -> Variant:
	return self.__lua_callk.call_wasm_catch([L, nargs, nresults, ctx, k])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __lua_load: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_load(L: int, reader: int, data: int, chunkname: int, mode: int) -> Variant:
	return self.__lua_load.call_wasm_catch([L, reader, data, chunkname, mode])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_dump: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_dump(L: int, writer: int, data: int, strip: int) -> Variant:
	return self.__lua_dump.call_wasm_catch([L, writer, data, strip])

# ["func_type", ["i32"], ["i32"]]
var __lua_status: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_status(L: int) -> Variant:
	return self.__lua_status.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __lua_error: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_error(L: int) -> Variant:
	return self.__lua_error.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_next: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_next(L: int, idx: int) -> Variant:
	return self.__lua_next.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], []]
var __lua_toclose: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_toclose(L: int, idx: int) -> Variant:
	return self.__lua_toclose.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], []]
var __lua_len: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_len(L: int, idx: int) -> Variant:
	return self.__lua_len.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_getallocf: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getallocf(L: int, ud: int) -> Variant:
	return self.__lua_getallocf.call_wasm_catch([L, ud])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_setallocf: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setallocf(L: int, f: int, ud: int) -> Variant:
	return self.__lua_setallocf.call_wasm_catch([L, f, ud])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_setwarnf: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setwarnf(L: int, f: int, ud: int) -> Variant:
	return self.__lua_setwarnf.call_wasm_catch([L, f, ud])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_newuserdatauv: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_newuserdatauv(L: int, size: int, nuvalue: int) -> Variant:
	return self.__lua_newuserdatauv.call_wasm_catch([L, size, nuvalue])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getupvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getupvalue(L: int, funcindex: int, n: int) -> Variant:
	return self.__lua_getupvalue.call_wasm_catch([L, funcindex, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_setupvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setupvalue(L: int, funcindex: int, n: int) -> Variant:
	return self.__lua_setupvalue.call_wasm_catch([L, funcindex, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_upvalueid: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_upvalueid(L: int, fidx: int, n: int) -> Variant:
	return self.__lua_upvalueid.call_wasm_catch([L, fidx, n])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], []]
var __lua_upvaluejoin: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_upvaluejoin(L: int, fidx1: int, n1: int, fidx2: int, n2: int) -> Variant:
	return self.__lua_upvaluejoin.call_wasm_catch([L, fidx1, n1, fidx2, n2])

# ["func_type", ["i32"], ["i32"]]
var __lua_gethook: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_gethook(L: int) -> Variant:
	return self.__lua_gethook.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __lua_gethookmask: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_gethookmask(L: int) -> Variant:
	return self.__lua_gethookmask.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __lua_gethookcount: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_gethookcount(L: int) -> Variant:
	return self.__lua_gethookcount.call_wasm_catch([L])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getstack: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getstack(L: int, level: int, ar: int) -> Variant:
	return self.__lua_getstack.call_wasm_catch([L, level, ar])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getlocal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getlocal(L: int, ar: int, n: int) -> Variant:
	return self.__lua_getlocal.call_wasm_catch([L, ar, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_setlocal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_setlocal(L: int, ar: int, n: int) -> Variant:
	return self.__lua_setlocal.call_wasm_catch([L, ar, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getinfo: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_getinfo(L: int, what: int, ar: int) -> Variant:
	return self.__lua_getinfo.call_wasm_catch([L, what, ar])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_resume: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_resume(L: int, from: int, nargs: int, nresults: int) -> Variant:
	return self.__lua_resume.call_wasm_catch([L, from, nargs, nresults])

# ["func_type", ["i32"], ["i32"]]
var __lua_isyieldable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_isyieldable(L: int) -> Variant:
	return self.__lua_isyieldable.call_wasm_catch([L])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_yieldk: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_yieldk(L: int, nresults: int, ctx: int, k: int) -> Variant:
	return self.__lua_yieldk.call_wasm_catch([L, nresults, ctx, k])

# ["func_type", ["i32"], ["i32"]]
var __lua_newthread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_newthread(L: int) -> Variant:
	return self.__lua_newthread.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_closethread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_closethread(L: int, from: int) -> Variant:
	return self.__lua_closethread.call_wasm_catch([L, from])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_newstate: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_newstate(f: int, ud: int, seed: int) -> Variant:
	return self.__lua_newstate.call_wasm_catch([f, ud, seed])

# ["func_type", ["i32"], []]
var __lua_close: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func lua_close(L: int) -> Variant:
	return self.__lua_close.call_wasm_catch([L])

# ["func_type", ["i32"], []]
var __luaL_pushresult: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_pushresult(B: int) -> Variant:
	return self.__luaL_pushresult.call_wasm_catch([B])

# ["func_type", ["i32", "i32"], []]
var __luaL_buffinit: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_buffinit(L: int, B: int) -> Variant:
	return self.__luaL_buffinit.call_wasm_catch([L, B])

# ["func_type", ["i32", "i32"], []]
var __luaL_addstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_addstring(B: int, s: int) -> Variant:
	return self.__luaL_addstring.call_wasm_catch([B, s])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_prepbuffsize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_prepbuffsize(B: int, sz: int) -> Variant:
	return self.__luaL_prepbuffsize.call_wasm_catch([B, sz])

# ["func_type", ["i32"], []]
var __luaL_addvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_addvalue(B: int) -> Variant:
	return self.__luaL_addvalue.call_wasm_catch([B])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_argerror: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_argerror(L: int, arg: int, extramsg: int) -> Variant:
	return self.__luaL_argerror.call_wasm_catch([L, arg, extramsg])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_typeerror: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_typeerror(L: int, arg: int, tname: int) -> Variant:
	return self.__luaL_typeerror.call_wasm_catch([L, arg, tname])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_getmetafield: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_getmetafield(L: int, obj: int, event: int) -> Variant:
	return self.__luaL_getmetafield.call_wasm_catch([L, obj, event])

# ["func_type", ["i32", "i32"], []]
var __luaL_where: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_where(L: int, level: int) -> Variant:
	return self.__luaL_where.call_wasm_catch([L, level])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_fileresult: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_fileresult(L: int, stat: int, fname: int) -> Variant:
	return self.__luaL_fileresult.call_wasm_catch([L, stat, fname])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_execresult: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_execresult(L: int, stat: int) -> Variant:
	return self.__luaL_execresult.call_wasm_catch([L, stat])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_newmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_newmetatable(L: int, tname: int) -> Variant:
	return self.__luaL_newmetatable.call_wasm_catch([L, tname])

# ["func_type", ["i32", "i32"], []]
var __luaL_setmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_setmetatable(L: int, tname: int) -> Variant:
	return self.__luaL_setmetatable.call_wasm_catch([L, tname])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_testudata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_testudata(L: int, ud: int, tname: int) -> Variant:
	return self.__luaL_testudata.call_wasm_catch([L, ud, tname])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_checkudata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checkudata(L: int, ud: int, tname: int) -> Variant:
	return self.__luaL_checkudata.call_wasm_catch([L, ud, tname])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_checkoption: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checkoption(L: int, arg: int, def: int, lst: int) -> Variant:
	return self.__luaL_checkoption.call_wasm_catch([L, arg, def, lst])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_optlstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_optlstring(L: int, arg: int, def: int, len: int) -> Variant:
	return self.__luaL_optlstring.call_wasm_catch([L, arg, def, len])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_checklstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checklstring(L: int, arg: int, len: int) -> Variant:
	return self.__luaL_checklstring.call_wasm_catch([L, arg, len])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_checktype: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checktype(L: int, arg: int, t: int) -> Variant:
	return self.__luaL_checktype.call_wasm_catch([L, arg, t])

# ["func_type", ["i32", "i32"], []]
var __luaL_checkany: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checkany(L: int, arg: int) -> Variant:
	return self.__luaL_checkany.call_wasm_catch([L, arg])

# ["func_type", ["i32", "i32"], ["f64"]]
var __luaL_checknumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checknumber(L: int, arg: int) -> Variant:
	return self.__luaL_checknumber.call_wasm_catch([L, arg])

# ["func_type", ["i32", "i32", "f64"], ["f64"]]
var __luaL_optnumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_optnumber(L: int, arg: int, def: float) -> Variant:
	return self.__luaL_optnumber.call_wasm_catch([L, arg, def])

# ["func_type", ["i32", "i32"], ["i64"]]
var __luaL_checkinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_checkinteger(L: int, arg: int) -> Variant:
	return self.__luaL_checkinteger.call_wasm_catch([L, arg])

# ["func_type", ["i32", "i32", "i64"], ["i64"]]
var __luaL_optinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_optinteger(L: int, arg: int, def: int) -> Variant:
	return self.__luaL_optinteger.call_wasm_catch([L, arg, def])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_setfuncs: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_setfuncs(L: int, l: int, nup: int) -> Variant:
	return self.__luaL_setfuncs.call_wasm_catch([L, l, nup])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_addlstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_addlstring(B: int, s: int, l: int) -> Variant:
	return self.__luaL_addlstring.call_wasm_catch([B, s, l])

# ["func_type", ["i32", "i32"], []]
var __luaL_pushresultsize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_pushresultsize(B: int, sz: int) -> Variant:
	return self.__luaL_pushresultsize.call_wasm_catch([B, sz])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_buffinitsize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_buffinitsize(L: int, B: int, sz: int) -> Variant:
	return self.__luaL_buffinitsize.call_wasm_catch([L, B, sz])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_ref: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_ref(L: int, t: int) -> Variant:
	return self.__luaL_ref.call_wasm_catch([L, t])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_unref: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_unref(L: int, t: int, ref: int) -> Variant:
	return self.__luaL_unref.call_wasm_catch([L, t, ref])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_loadstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_loadstring(L: int, s: int) -> Variant:
	return self.__luaL_loadstring.call_wasm_catch([L, s])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_getsubtable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_getsubtable(L: int, idx: int, fname: int) -> Variant:
	return self.__luaL_getsubtable.call_wasm_catch([L, idx, fname])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __luaL_requiref: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_requiref(L: int, modname: int, openf: int, glb: int) -> Variant:
	return self.__luaL_requiref.call_wasm_catch([L, modname, openf, glb])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __luaL_addgsub: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_addgsub(b: int, s: int, p: int, r: int) -> Variant:
	return self.__luaL_addgsub.call_wasm_catch([b, s, p, r])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_gsub: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_gsub(L: int, s: int, p: int, r: int) -> Variant:
	return self.__luaL_gsub.call_wasm_catch([L, s, p, r])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_alloc: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_alloc(ud: int, ptr: int, osize: int, nsize: int) -> Variant:
	return self.__luaL_alloc.call_wasm_catch([ud, ptr, osize, nsize])

# ["func_type", ["i32"], ["i32"]]
var __luaL_makeseed: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaL_makeseed(L: int) -> Variant:
	return self.__luaL_makeseed.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_base: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_base(L: int) -> Variant:
	return self.__luaopen_base.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_coroutine: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_coroutine(L: int) -> Variant:
	return self.__luaopen_coroutine.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_debug: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_debug(L: int) -> Variant:
	return self.__luaopen_debug.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_io: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_io(L: int) -> Variant:
	return self.__luaopen_io.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_math: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_math(L: int) -> Variant:
	return self.__luaopen_math.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_package: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_package(L: int) -> Variant:
	return self.__luaopen_package.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_os: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_os(L: int) -> Variant:
	return self.__luaopen_os.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_string: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_string(L: int) -> Variant:
	return self.__luaopen_string.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_table: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_table(L: int) -> Variant:
	return self.__luaopen_table.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __luaopen_utf8: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
func luaopen_utf8(L: int) -> Variant:
	return self.__luaopen_utf8.call_wasm_catch([L])


func _init(instance: WasmInstance):
	# ["memory", false, false, 16, 2]
	self.memory = instance.get_memory("memory")
	
	# ["global_type", "var", "i32"]
	# ???
	
	# ["func_type", [], []]
	self.___initialize = instance.get_func("_initialize")
	
	# ["table", ["ref_type", true, "func"], false, 202]
	self.__indirect_function_table = instance.get_table("__indirect_function_table")
	
	# ["tag_type", ["func_type", ["i32"], []]]
	# ???
	
	# ["func_type", [], ["i32"]]
	self.__luaL_newstate = instance.get_func("luaL_newstate")
	
	# ["func_type", [], ["i32"]]
	self.__get_global_state = instance.get_func("get_global_state")
	
	# ["func_type", ["i32"], ["i32"]]
	self.___malloc = instance.get_func("malloc")
	
	# ["func_type", ["i32"], []]
	self.___free = instance.get_func("free")
	
	# ["func_type", [], ["i32"]]
	self.__main_cli = instance.get_func("main_cli")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_gettop = instance.get_func("lua_gettop")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_gc = instance.get_func("lua_gc")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_pushcclosure = instance.get_func("lua_pushcclosure")
	
	# ["func_type", ["i32", "i64"], []]
	self.__lua_pushinteger = instance.get_func("lua_pushinteger")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_pushlightuserdata = instance.get_func("lua_pushlightuserdata")
	
	# ["func_type", ["i32", "i32", "i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_pcallk = instance.get_func("lua_pcallk")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_toboolean = instance.get_func("lua_toboolean")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_tolstring = instance.get_func("lua_tolstring")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_settop = instance.get_func("lua_settop")
	
	# ["func_type", ["i32", "i32", "i32"], ["i64"]]
	self.__lua_tointegerx = instance.get_func("lua_tointegerx")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_touserdata = instance.get_func("lua_touserdata")
	
	# ["func_type", ["i32", "f64", "i32"], []]
	self.__luaL_checkversion_ = instance.get_func("luaL_checkversion_")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_pushboolean = instance.get_func("lua_pushboolean")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_setfield = instance.get_func("lua_setfield")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__luaL_openselectedlibs = instance.get_func("luaL_openselectedlibs")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_createtable = instance.get_func("lua_createtable")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_pushstring = instance.get_func("lua_pushstring")
	
	# ["func_type", ["i32", "i32", "i64"], []]
	self.__lua_rawseti = instance.get_func("lua_rawseti")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_setglobal = instance.get_func("lua_setglobal")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_loadfilex = instance.get_func("luaL_loadfilex")
	
	# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
	self.__luaL_loadbufferx = instance.get_func("luaL_loadbufferx")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_warning = instance.get_func("lua_warning")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_getglobal = instance.get_func("lua_getglobal")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_rotate = instance.get_func("lua_rotate")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_error = instance.get_func("luaL_error")
	
	# ["func_type", ["i32", "i32"], ["i64"]]
	self.__luaL_len = instance.get_func("luaL_len")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__luaL_checkstack = instance.get_func("luaL_checkstack")
	
	# ["func_type", ["i32", "i32", "i64"], ["i32"]]
	self.__lua_rawgeti = instance.get_func("lua_rawgeti")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_tolstring = instance.get_func("luaL_tolstring")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_pushlstring = instance.get_func("lua_pushlstring")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_pushfstring = instance.get_func("lua_pushfstring")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_concat = instance.get_func("lua_concat")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_callmeta = instance.get_func("luaL_callmeta")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_type = instance.get_func("lua_type")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_typename = instance.get_func("lua_typename")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], []]
	self.__luaL_traceback = instance.get_func("luaL_traceback")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], []]
	self.__lua_sethook = instance.get_func("lua_sethook")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_checkstack = instance.get_func("lua_checkstack")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_xmove = instance.get_func("lua_xmove")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_atpanic = instance.get_func("lua_atpanic")
	
	# ["func_type", ["i32"], ["f64"]]
	self.__lua_version = instance.get_func("lua_version")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_absindex = instance.get_func("lua_absindex")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_closeslot = instance.get_func("lua_closeslot")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_copy = instance.get_func("lua_copy")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_pushvalue = instance.get_func("lua_pushvalue")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_iscfunction = instance.get_func("lua_iscfunction")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_isinteger = instance.get_func("lua_isinteger")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_isnumber = instance.get_func("lua_isnumber")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_isstring = instance.get_func("lua_isstring")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_isuserdata = instance.get_func("lua_isuserdata")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_rawequal = instance.get_func("lua_rawequal")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_arith = instance.get_func("lua_arith")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_compare = instance.get_func("lua_compare")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_numbertocstring = instance.get_func("lua_numbertocstring")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_stringtonumber = instance.get_func("lua_stringtonumber")
	
	# ["func_type", ["i32", "i32", "i32"], ["f64"]]
	self.__lua_tonumberx = instance.get_func("lua_tonumberx")
	
	# ["func_type", ["i32", "i32"], ["i64"]]
	self.__lua_rawlen = instance.get_func("lua_rawlen")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_tocfunction = instance.get_func("lua_tocfunction")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_tothread = instance.get_func("lua_tothread")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_topointer = instance.get_func("lua_topointer")
	
	# ["func_type", ["i32"], []]
	self.__lua_pushnil = instance.get_func("lua_pushnil")
	
	# ["func_type", ["i32", "f64"], []]
	self.__lua_pushnumber = instance.get_func("lua_pushnumber")
	
	# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_pushexternalstring = instance.get_func("lua_pushexternalstring")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_pushvfstring = instance.get_func("lua_pushvfstring")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_pushthread = instance.get_func("lua_pushthread")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_gettable = instance.get_func("lua_gettable")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_getfield = instance.get_func("lua_getfield")
	
	# ["func_type", ["i32", "i32", "i64"], ["i32"]]
	self.__lua_geti = instance.get_func("lua_geti")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_rawget = instance.get_func("lua_rawget")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_rawgetp = instance.get_func("lua_rawgetp")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_getmetatable = instance.get_func("lua_getmetatable")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_getiuservalue = instance.get_func("lua_getiuservalue")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_settable = instance.get_func("lua_settable")
	
	# ["func_type", ["i32", "i32", "i64"], []]
	self.__lua_seti = instance.get_func("lua_seti")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_rawset = instance.get_func("lua_rawset")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_rawsetp = instance.get_func("lua_rawsetp")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_setmetatable = instance.get_func("lua_setmetatable")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_setiuservalue = instance.get_func("lua_setiuservalue")
	
	# ["func_type", ["i32", "i32", "i32", "i32", "i32"], []]
	self.__lua_callk = instance.get_func("lua_callk")
	
	# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_load = instance.get_func("lua_load")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_dump = instance.get_func("lua_dump")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_status = instance.get_func("lua_status")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_error = instance.get_func("lua_error")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_next = instance.get_func("lua_next")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_toclose = instance.get_func("lua_toclose")
	
	# ["func_type", ["i32", "i32"], []]
	self.__lua_len = instance.get_func("lua_len")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_getallocf = instance.get_func("lua_getallocf")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_setallocf = instance.get_func("lua_setallocf")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__lua_setwarnf = instance.get_func("lua_setwarnf")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_newuserdatauv = instance.get_func("lua_newuserdatauv")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_getupvalue = instance.get_func("lua_getupvalue")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_setupvalue = instance.get_func("lua_setupvalue")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_upvalueid = instance.get_func("lua_upvalueid")
	
	# ["func_type", ["i32", "i32", "i32", "i32", "i32"], []]
	self.__lua_upvaluejoin = instance.get_func("lua_upvaluejoin")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_gethook = instance.get_func("lua_gethook")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_gethookmask = instance.get_func("lua_gethookmask")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_gethookcount = instance.get_func("lua_gethookcount")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_getstack = instance.get_func("lua_getstack")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_getlocal = instance.get_func("lua_getlocal")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_setlocal = instance.get_func("lua_setlocal")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_getinfo = instance.get_func("lua_getinfo")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_resume = instance.get_func("lua_resume")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_isyieldable = instance.get_func("lua_isyieldable")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__lua_yieldk = instance.get_func("lua_yieldk")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__lua_newthread = instance.get_func("lua_newthread")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__lua_closethread = instance.get_func("lua_closethread")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__lua_newstate = instance.get_func("lua_newstate")
	
	# ["func_type", ["i32"], []]
	self.__lua_close = instance.get_func("lua_close")
	
	# ["func_type", ["i32"], []]
	self.__luaL_pushresult = instance.get_func("luaL_pushresult")
	
	# ["func_type", ["i32", "i32"], []]
	self.__luaL_buffinit = instance.get_func("luaL_buffinit")
	
	# ["func_type", ["i32", "i32"], []]
	self.__luaL_addstring = instance.get_func("luaL_addstring")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__luaL_prepbuffsize = instance.get_func("luaL_prepbuffsize")
	
	# ["func_type", ["i32"], []]
	self.__luaL_addvalue = instance.get_func("luaL_addvalue")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_argerror = instance.get_func("luaL_argerror")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_typeerror = instance.get_func("luaL_typeerror")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_getmetafield = instance.get_func("luaL_getmetafield")
	
	# ["func_type", ["i32", "i32"], []]
	self.__luaL_where = instance.get_func("luaL_where")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_fileresult = instance.get_func("luaL_fileresult")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__luaL_execresult = instance.get_func("luaL_execresult")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__luaL_newmetatable = instance.get_func("luaL_newmetatable")
	
	# ["func_type", ["i32", "i32"], []]
	self.__luaL_setmetatable = instance.get_func("luaL_setmetatable")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_testudata = instance.get_func("luaL_testudata")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_checkudata = instance.get_func("luaL_checkudata")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__luaL_checkoption = instance.get_func("luaL_checkoption")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__luaL_optlstring = instance.get_func("luaL_optlstring")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_checklstring = instance.get_func("luaL_checklstring")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__luaL_checktype = instance.get_func("luaL_checktype")
	
	# ["func_type", ["i32", "i32"], []]
	self.__luaL_checkany = instance.get_func("luaL_checkany")
	
	# ["func_type", ["i32", "i32"], ["f64"]]
	self.__luaL_checknumber = instance.get_func("luaL_checknumber")
	
	# ["func_type", ["i32", "i32", "f64"], ["f64"]]
	self.__luaL_optnumber = instance.get_func("luaL_optnumber")
	
	# ["func_type", ["i32", "i32"], ["i64"]]
	self.__luaL_checkinteger = instance.get_func("luaL_checkinteger")
	
	# ["func_type", ["i32", "i32", "i64"], ["i64"]]
	self.__luaL_optinteger = instance.get_func("luaL_optinteger")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__luaL_setfuncs = instance.get_func("luaL_setfuncs")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__luaL_addlstring = instance.get_func("luaL_addlstring")
	
	# ["func_type", ["i32", "i32"], []]
	self.__luaL_pushresultsize = instance.get_func("luaL_pushresultsize")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_buffinitsize = instance.get_func("luaL_buffinitsize")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__luaL_ref = instance.get_func("luaL_ref")
	
	# ["func_type", ["i32", "i32", "i32"], []]
	self.__luaL_unref = instance.get_func("luaL_unref")
	
	# ["func_type", ["i32", "i32"], ["i32"]]
	self.__luaL_loadstring = instance.get_func("luaL_loadstring")
	
	# ["func_type", ["i32", "i32", "i32"], ["i32"]]
	self.__luaL_getsubtable = instance.get_func("luaL_getsubtable")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], []]
	self.__luaL_requiref = instance.get_func("luaL_requiref")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], []]
	self.__luaL_addgsub = instance.get_func("luaL_addgsub")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__luaL_gsub = instance.get_func("luaL_gsub")
	
	# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
	self.__luaL_alloc = instance.get_func("luaL_alloc")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaL_makeseed = instance.get_func("luaL_makeseed")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_base = instance.get_func("luaopen_base")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_coroutine = instance.get_func("luaopen_coroutine")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_debug = instance.get_func("luaopen_debug")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_io = instance.get_func("luaopen_io")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_math = instance.get_func("luaopen_math")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_package = instance.get_func("luaopen_package")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_os = instance.get_func("luaopen_os")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_string = instance.get_func("luaopen_string")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_table = instance.get_func("luaopen_table")
	
	# ["func_type", ["i32"], ["i32"]]
	self.__luaopen_utf8 = instance.get_func("luaopen_utf8")
	