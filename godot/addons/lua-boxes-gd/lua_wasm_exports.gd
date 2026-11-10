extends RefCounted
class_name LuaWasmExports


## 4.6 – Functions and Types [br]
##  [br]
## Here we list all functions and types from the C API in alphabetical order. Each function has an indicator like this: [br]
## [-o, +p, x] [br]
## [br]
## The first field, o, is how many elements the function pops from the stack. [br]
## The second field, p, is how many elements the function pushes onto the stack. (Any function always pushes its results after popping its arguments.) [br]
## A field in the form x|y means the function can push (or pop) x or y elements, depending on the situation; an interrogation mark '?' means that we cannot know how many elements the function pops/pushes by looking only at its arguments. (For instance, they may depend on what is in the stack.) [br]
## The third field, x, tells whether the function may raise errors: [br]
## - '-' means the function never raises any error; [br]
## - 'm' means the function may raise only out-of-memory errors; [br]
## - 'v' means the function may raise the errors explained in the text; [br]
## - 'e' means the function can run arbitrary Lua code, either directly or through metamethods, and therefore may raise any errors. [br]


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
## [br][br]
## [-0, +0, –] [br]
## [code]lua_State *luaL_newstate (void);[/code] [br]
##  [br]
##  Creates a new Lua state. It calls [method lua_newstate] with [method luaL_alloc] as the allocator function and the result of [code]luaL_makeseed(NULL)[/code] as the seed, and then sets a warning function and a panic function (see [code]§4.4[/code]) that print messages to the standard error output.    [br]
##  Returns the new state, or [code]NULL[/code] if there is a memory allocation error.       [br]
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
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_gettop (lua_State *L);[/code] [br]
##  [br]
##  Returns the index of the top element in the stack. Because indices start at 1, this result is equal to the number of elements in the stack; in particular, 0 means an empty stack.       [br]
func lua_gettop(L: int) -> Variant:
	return self.__lua_gettop.call_wasm_catch([L])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_gc: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_gc (lua_State *L, int what, ...);[/code] [br]
##  [br]
##  Controls the garbage collector.    [br]
##  This function performs several tasks, according to the value of the parameter [code]what[/code]. For options that need extra arguments, they are listed after the option.  [code]LUA_GCCOLLECT[/code]:  Performs a full garbage-collection cycle. [code]LUA_GCSTOP[/code]:  Stops the garbage collector. [code]LUA_GCRESTART[/code]:  Restarts the garbage collector. [code]LUA_GCCOUNT[/code]:  Returns the current amount of memory (in Kbytes) in use by Lua. [code]LUA_GCCOUNTB[/code]:  Returns the remainder of dividing the current amount of bytes of memory in use by Lua by 1024. [code]LUA_GCSTEP[/code] (size_t n):  Performs a step of garbage collection. [code]LUA_GCISRUNNING[/code]:  Returns a boolean that tells whether the collector is running (i.e., not stopped). [code]LUA_GCINC[/code]:  Changes the collector to incremental mode. Returns the previous mode ([code]LUA_GCGEN[/code] or [code]LUA_GCINC[/code]). [code]LUA_GCGEN[/code]:  Changes the collector to generational mode. Returns the previous mode ([code]LUA_GCGEN[/code] or [code]LUA_GCINC[/code]). [code]LUA_GCPARAM[/code] (int param, int val):  Changes and/or returns the value of a parameter of the collector. If [code]val[/code] is -1, the call only returns the current value. The argument [code]param[/code] must have one of the following values:  [code]LUA_GCPMINORMUL[/code]:  The minor multiplier. [code]LUA_GCPMAJORMINOR[/code]:  The major-minor multiplier. [code]LUA_GCPMINORMAJOR[/code]:  The minor-major multiplier. [code]LUA_GCPPAUSE[/code]:  The garbage-collector pause. [code]LUA_GCPSTEPMUL[/code]:  The step multiplier. [code]LUA_GCPSTEPSIZE[/code]:  The step size.  [br]
##  For more details about these options, see [code]collectgarbage[/code][/code].    [br]
##  This function should not be called by a finalizer.       [br]
func lua_gc(L: int, what: int, va_list_argp: int) -> Variant:
	return self.__lua_gc.call_wasm_catch([L, what, va_list_argp])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_pushcclosure: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-n, +1, m] [br]
## [code]void lua_pushcclosure (lua_State *L, lua_CFunction fn, int n);[/code] [br]
##  [br]
##  Pushes a new C closure onto the stack. This function receives a pointer to a C function and pushes onto the stack a Lua value of type [code]function[/code] that, when called, invokes the corresponding C function. The parameter [code]n[/code] tells how many upvalues this function will have (see [code]§4.2[/code]).    [br]
##  Any function to be callable by Lua must follow the correct protocol to receive its parameters and return its results (see [method lua_CFunction]).    [br]
##  When a C function is created, it is possible to associate some values with it, the so called upvalues; these upvalues are then accessible to the function whenever it is called. This association is called a C closure (see [code]§4.2[/code]). To create a C closure, first the initial values for its upvalues must be pushed onto the stack. (When there are multiple upvalues, the first value is pushed first.) Then [method lua_pushcclosure] is called to create and push the C function onto the stack, with the argument [code]n[/code] telling how many values will be associated with the function. [method lua_pushcclosure] also pops these values from the stack.    [br]
##  The maximum value for [code]n[/code] is 255.    [br]
##  When [code]n[/code] is zero, this function creates a light C function, which is just a pointer to the C function. In that case, it never raises a memory error.       [br]
func lua_pushcclosure(L: int, fn: int, n: int) -> Variant:
	return self.__lua_pushcclosure.call_wasm_catch([L, fn, n])

# ["func_type", ["i32", "i64"], []]
var __lua_pushinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]void lua_pushinteger (lua_State *L, lua_Integer n);[/code] [br]
##  [br]
##  Pushes an integer with value [code]n[/code] onto the stack.       [br]
func lua_pushinteger(L: int, n: int) -> Variant:
	return self.__lua_pushinteger.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32"], []]
var __lua_pushlightuserdata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]void lua_pushlightuserdata (lua_State *L, void *p);[/code] [br]
##  [br]
##  Pushes a light userdata onto the stack.    [br]
##  Userdata represent C values in Lua. A light userdata represents a pointer, a [code]void*[/code]. It is a value (like a number): you do not create it, it has no individual metatable, and it is not collected (as it was never created). A light userdata is equal to "any" light userdata with the same C address.       [br]
func lua_pushlightuserdata(L: int, p: int) -> Variant:
	return self.__lua_pushlightuserdata.call_wasm_catch([L, p])

# ["func_type", ["i32", "i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __lua_pcallk: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-(nargs + 1), +(nresults|1), –] [br]
## [code]int lua_pcallk (lua_State *L,                 int nargs,                 int nresults,                 int msgh,                 lua_KContext ctx,                 lua_KFunction k);[/code] [br]
##  [br]
##  This function behaves exactly like [method lua_pcall], except that it allows the called function to yield (see [code]§4.5[/code]).       [br]
func lua_pcallk(L: int, nargs: int, nresults: int, errfunc: int, ctx: int, k: int) -> Variant:
	return self.__lua_pcallk.call_wasm_catch([L, nargs, nresults, errfunc, ctx, k])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_toboolean: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_toboolean (lua_State *L, int index);[/code] [br]
##  [br]
##  Converts the Lua value at the given index to a C boolean value (0 or 1). Like all tests in Lua, [method lua_toboolean] returns true for any Lua value different from false and nil; otherwise it returns false. (If you want to accept only actual boolean values, use [method lua_isboolean] to test the value's type.)       [br]
func lua_toboolean(L: int, idx: int) -> Variant:
	return self.__lua_toboolean.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_tolstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, m] [br]
## [code]const char *lua_tolstring (lua_State *L, int index, size_t *len);[/code] [br]
##  [br]
##  Converts the Lua value at the given index to a C string. The Lua value must be a string or a number; otherwise, the function returns [code]NULL[/code]. If the value is a number, then [code]lua_tolstring[/code] also changes the actual value in the stack to a string. (This change confuses [method lua_next] when [code]lua_tolstring[/code] is applied to keys during a table traversal.)    [br]
##  If [code]len[/code] is not [code]NULL[/code], the function sets [code]*len[/code] with the string length. The returned C string always has a zero ('[code]\0[/code]') after its last character, but can contain other zeros in its body.    [br]
##  The pointer returned by [code]lua_tolstring[/code] may be invalidated by the garbage collector if the corresponding Lua value is removed from the stack (see [code]§4.1.3[/code]).    [br]
##  This function can raise memory errors only when converting a number to a string (as then it may create a new string).       [br]
func lua_tolstring(L: int, idx: int, len: int) -> Variant:
	return self.__lua_tolstring.call_wasm_catch([L, idx, len])

# ["func_type", ["i32", "i32"], []]
var __lua_settop: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, e] [br]
## [code]void lua_settop (lua_State *L, int index);[/code] [br]
##  [br]
##  Receives any acceptable stack index, or 0, and sets the stack top to this index. If the new top is greater than the old one, then the new elements are filled with nil. If [code]index[/code] is 0, then all stack elements are removed.    [br]
##  This function can run arbitrary code when removing an index marked as to-be-closed from the stack.       [br]
func lua_settop(L: int, idx: int) -> Variant:
	return self.__lua_settop.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i64"]]
var __lua_tointegerx: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_Integer lua_tointegerx (lua_State *L, int index, int *isnum);[/code] [br]
##  [br]
##  Converts the Lua value at the given index to the signed integral type [method lua_Integer]. The Lua value must be an integer, or a number or string convertible to an integer (see [code]§3.4.3[/code]); otherwise, [code]lua_tointegerx[/code] returns 0.    [br]
##  If [code]isnum[/code] is not [code]NULL[/code], its referent is assigned a boolean value that indicates whether the operation succeeded.       [br]
func lua_tointegerx(L: int, idx: int, pisnum: int) -> Variant:
	return self.__lua_tointegerx.call_wasm_catch([L, idx, pisnum])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_touserdata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void *lua_touserdata (lua_State *L, int index);[/code] [br]
##  [br]
##  If the value at the given index is a full userdata, returns its memory-block address. If the value is a light userdata, returns its value (a pointer). Otherwise, returns [code]NULL[/code].       [br]
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
## [br][br]
## [-0, +1, –] [br]
## [code]void lua_pushboolean (lua_State *L, int b);[/code] [br]
##  [br]
##  Pushes a boolean value with value [code]b[/code] onto the stack.       [br]
func lua_pushboolean(L: int, b: int) -> Variant:
	return self.__lua_pushboolean.call_wasm_catch([L, b])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_setfield: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, e] [br]
## [code]void lua_setfield (lua_State *L, int index, const char *k);[/code] [br]
##  [br]
##  Does the equivalent to [code]t[k] = v[/code], where [code]t[/code] is the value at the given index and [code]v[/code] is the value on the top of the stack.    [br]
##  This function pops the value from the stack. As in Lua, this function may trigger a metamethod for the "newindex" event (see [code]§2.4[/code]).       [br]
func lua_setfield(L: int, idx: int, k: int) -> Variant:
	return self.__lua_setfield.call_wasm_catch([L, idx, k])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_openselectedlibs: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, e] [br]
## [code]void luaL_openselectedlibs (lua_State *L, int load, int preload);[/code] [br]
##  [br]
##  Opens (loads) and preloads selected standard libraries into the state [code]L[/code]. (To preload means to add the library loader into the table [code]package.preload[/code][/code], so that the library can be required later by the program. Keep in mind that [code]require[/code][/code] itself is provided by the package library. If a program does not load that library, it will be unable to require anything.)    [br]
##  The integer [code]load[/code] selects which libraries to load; the integer [code]preload[/code] selects which to preload, among those not loaded. Both are masks formed by a bitwise OR of the following constants:  [code]LUA_GLIBK[/code]:  the basic library.[code]LUA_LOADLIBK[/code]:  the package library.[code]LUA_COLIBK[/code]:  the coroutine library.[code]LUA_STRLIBK[/code]:  the string library.[code]LUA_UTF8LIBK[/code]:  the UTF-8 library.[code]LUA_TABLIBK[/code]:  the table library.[code]LUA_MATHLIBK[/code]:  the mathematical library.[code]LUA_IOLIBK[/code]:  the I/O library.[code]LUA_OSLIBK[/code]:  the operating system library.[code]LUA_DBLIBK[/code]:  the debug library.       6.2 – Basic Functions [br]
##  The basic library provides core functions to Lua. If you do not include this library in your application, you should check carefully whether you need to provide implementations for some of its facilities.    [br]
func luaL_openselectedlibs(L: int, load_: int, preload_: int) -> Variant:
	return self.__luaL_openselectedlibs.call_wasm_catch([L, load_, preload_])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_createtable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]void lua_createtable (lua_State *L, int nseq, int nrec);[/code] [br]
##  [br]
##  Creates a new empty table and pushes it onto the stack. Parameter [code]nseq[/code] is a hint for how many elements the table will have as a sequence; parameter [code]nrec[/code] is a hint for how many other elements the table will have. Lua may use these hints to preallocate memory for the new table. This preallocation may help performance when you know in advance how many elements the table will have. Otherwise you should use the function [method lua_newtable].       [br]
func lua_createtable(L: int, narray: int, nrec: int) -> Variant:
	return self.__lua_createtable.call_wasm_catch([L, narray, nrec])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_pushstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]const char *lua_pushstring (lua_State *L, const char *s);[/code] [br]
##  [br]
##  Pushes the zero-terminated string pointed to by [code]s[/code] onto the stack. Lua will make or reuse an internal copy of the given string, so the memory at [code]s[/code] can be freed or reused immediately after the function returns.    [br]
##  Returns a pointer to the internal copy of the string (see [code]§4.1.3[/code]).    [br]
##  If [code]s[/code] is [code]NULL[/code], pushes nil and returns [code]NULL[/code].       [br]
func lua_pushstring(L: int, s: int) -> Variant:
	return self.__lua_pushstring.call_wasm_catch([L, s])

# ["func_type", ["i32", "i32", "i64"], []]
var __lua_rawseti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, m] [br]
## [code]void lua_rawseti (lua_State *L, int index, lua_Integer i);[/code] [br]
##  [br]
##  Does the equivalent of [code]t[i] = v[/code], where [code]t[/code] is the table at the given index and [code]v[/code] is the value on the top of the stack.    [br]
##  This function pops the value from the stack. The assignment is raw, that is, it does not use the [code]__newindex[/code] metavalue.       [br]
func lua_rawseti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_rawseti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], []]
var __lua_setglobal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, e] [br]
## [code]void lua_setglobal (lua_State *L, const char *name);[/code] [br]
##  [br]
##  Pops a value from the stack and sets it as the new value of global [code]name[/code].       [br]
func lua_setglobal(L: int, name: int) -> Variant:
	return self.__lua_setglobal.call_wasm_catch([L, name])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_loadfilex: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]int luaL_loadfilex (lua_State *L, const char *filename,                                             const char *mode);[/code] [br]
##  [br]
##  Loads a file as a Lua chunk. This function uses [method lua_load] to load the chunk in the file named [code]filename[/code]. If [code]filename[/code] is [code]NULL[/code], then it loads from the standard input. The first line in the file is ignored if it starts with a [code]#[/code].    [br]
##  The string [code]mode[/code] works as in the function [method lua_load].    [br]
##  This function returns the same results as [method lua_load], or [code]LUA_ERRFILE[/code][/code] for file-related errors.    [br]
##  As [method lua_load], this function only loads the chunk; it does not run it.       [br]
func luaL_loadfilex(L: int, filename: int, mode: int) -> Variant:
	return self.__luaL_loadfilex.call_wasm_catch([L, filename, mode])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_loadbufferx: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int luaL_loadbufferx (lua_State *L,                       const char *buff,                       size_t sz,                       const char *name,                       const char *mode);[/code] [br]
##  [br]
##  Loads a buffer as a Lua chunk. This function uses [method lua_load] to load the chunk in the buffer pointed to by [code]buff[/code] with size [code]sz[/code].    [br]
##  This function returns the same results as [method lua_load]. [code]name[/code] is the chunk name, used for debug information and error messages. The string [code]mode[/code] works as in the function [method lua_load]. In particular, this function supports mode '[code]B[/code]' for fixed buffers.       [br]
func luaL_loadbufferx(L: int, buff: int, size: int, name: int, mode: int) -> Variant:
	return self.__luaL_loadbufferx.call_wasm_catch([L, buff, size, name, mode])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_warning: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_warning (lua_State *L, const char *msg, int tocont);[/code] [br]
##  [br]
##  Emits a warning with the given message. A message in a call with [code]tocont[/code] true should be continued in another call to this function.    [br]
##  See [code]warn[/code][/code] for more details about warnings.       [br]
func lua_warning(L: int, msg: int, tocont: int) -> Variant:
	return self.__lua_warning.call_wasm_catch([L, msg, tocont])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_getglobal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]int lua_getglobal (lua_State *L, const char *name);[/code] [br]
##  [br]
##  Pushes onto the stack the value of the global [code]name[/code]. Returns the type of that value.       [br]
func lua_getglobal(L: int, name: int) -> Variant:
	return self.__lua_getglobal.call_wasm_catch([L, name])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_rotate: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_rotate (lua_State *L, int idx, int n);[/code] [br]
##  [br]
##  Rotates the stack elements between the valid index [code]idx[/code] and the top of the stack. The elements are rotated [code]n[/code] positions in the direction of the top, for a positive [code]n[/code], or [code]-n[/code] positions in the direction of the bottom, for a negative [code]n[/code]. The absolute value of [code]n[/code] must not be greater than the size of the slice being rotated. This function cannot be called with a pseudo-index, because a pseudo-index is not an actual stack position.       [br]
func lua_rotate(L: int, idx: int, n: int) -> Variant:
	return self.__lua_rotate.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_error: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]int luaL_error (lua_State *L, const char *fmt, ...);[/code] [br]
##  [br]
##  Raises an error. The error message format is given by [code]fmt[/code] plus any extra arguments, following the same rules of [method lua_pushfstring]. It also adds at the beginning of the message the file name and the line number where the error occurred, if this information is available.    [br]
##  This function never returns, but it is an idiom to use it in C functions as [code]return luaL_error(args)[/code].       [br]
func luaL_error(L: int, fmt: int, va_list_argp: int) -> Variant:
	return self.__luaL_error.call_wasm_catch([L, fmt, va_list_argp])

# ["func_type", ["i32", "i32"], ["i64"]]
var __luaL_len: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, e] [br]
## [code]lua_Integer luaL_len (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns the "length" of the value at the given index as a number; it is equivalent to the '[code]#[/code]' operator in Lua (see [code]§3.4.7[/code]). Raises an error if the result of the operation is not an integer. (This case can only happen through metamethods.)       [br]
func luaL_len(L: int, idx: int) -> Variant:
	return self.__luaL_len.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_checkstack: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]void luaL_checkstack (lua_State *L, int sz, const char *msg);[/code] [br]
##  [br]
##  Grows the stack size to [code]top + sz[/code] elements, raising an error if the stack cannot grow to that size. [code]msg[/code] is an additional text to go into the error message (or [code]NULL[/code] for no additional text).       [br]
func luaL_checkstack(L: int, space: int, msg: int) -> Variant:
	return self.__luaL_checkstack.call_wasm_catch([L, space, msg])

# ["func_type", ["i32", "i32", "i64"], ["i32"]]
var __lua_rawgeti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int lua_rawgeti (lua_State *L, int index, lua_Integer n);[/code] [br]
##  [br]
##  Pushes onto the stack the value [code]t[n][/code], where [code]t[/code] is the table at the given index. The access is raw, that is, it does not use the [code]__index[/code] metavalue.    [br]
##  Returns the type of the pushed value.       [br]
func lua_rawgeti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_rawgeti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_tolstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]const char *luaL_tolstring (lua_State *L, int idx, size_t *len);[/code] [br]
##  [br]
##  Converts any Lua value at the given index to a C string in a reasonable format. The resulting string is pushed onto the stack and also returned by the function (see [code]§4.1.3[/code]). If [code]len[/code] is not [code]NULL[/code], the function also sets [code]*len[/code] with the string length.    [br]
##  If the value has a metatable with a [code]__tostring[/code] field, then [code]luaL_tolstring[/code] calls the corresponding metamethod with the value as argument, and uses the result of the call as its result.       [br]
func luaL_tolstring(L: int, idx: int, len: int) -> Variant:
	return self.__luaL_tolstring.call_wasm_catch([L, idx, len])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_pushlstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, v] [br]
## [code]const char *lua_pushlstring (lua_State *L, const char *s, size_t len);[/code] [br]
##  [br]
##  Pushes the string pointed to by [code]s[/code] with size [code]len[/code] onto the stack. Lua will make or reuse an internal copy of the given string, so the memory at [code]s[/code] can be freed or reused immediately after the function returns. The string can contain any binary data, including embedded zeros.    [br]
##  Returns a pointer to the internal copy of the string (see [code]§4.1.3[/code]).    [br]
##  Besides memory allocation errors, this function may raise an error if the string is too large.       [br]
func lua_pushlstring(L: int, s: int, len: int) -> Variant:
	return self.__lua_pushlstring.call_wasm_catch([L, s, len])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_pushfstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, v] [br]
## [code]const char *lua_pushfstring (lua_State *L, const char *fmt, ...);[/code] [br]
##  [br]
##  Pushes onto the stack a formatted string and returns a pointer to this string (see [code]§4.1.3[/code]). The result is a copy of [code]fmt[/code] with each conversion specifier replaced by a string representation of its respective extra argument. A conversion specifier (and its corresponding extra argument) can be '[code]%%[/code]' (inserts the character '[code]%[/code]'), '[code]%s[/code]' (inserts a zero-terminated string, with no size restrictions), '[code]%f[/code]' (inserts a [method lua_Number]), '[code]%I[/code]' (inserts a [method lua_Integer]), '[code]%p[/code]' (inserts a void pointer), '[code]%d[/code]' (inserts an [code]int[/code]), '[code]%c[/code]' (inserts an [code]int[/code] as a one-byte character), and '[code]%U[/code]' (inserts an [code]unsigned long[/code] as a UTF-8 byte sequence).    [br]
##  Every occurrence of '[code]%[/code]' in the string [code]fmt[/code] must form a valid conversion specifier.    [br]
##  Besides memory allocation errors, this function may raise an error if the resulting string is too large.       [br]
func lua_pushfstring(L: int, fmt: int, va_list_argp: int) -> Variant:
	return self.__lua_pushfstring.call_wasm_catch([L, fmt, va_list_argp])

# ["func_type", ["i32", "i32"], []]
var __lua_concat: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-n, +1, e] [br]
## [code]void lua_concat (lua_State *L, int n);[/code] [br]
##  [br]
##  Concatenates the [code]n[/code] values at the top of the stack, pops them, and leaves the result on the top. If [code]n[/code] is 1, the result is the single value on the stack (that is, the function does nothing); if [code]n[/code] is 0, the result is the empty string. Concatenation is performed following the usual semantics of Lua (see [code]§3.4.6[/code]).       [br]
func lua_concat(L: int, n: int) -> Variant:
	return self.__lua_concat.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_callmeta: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +(0|1), e] [br]
## [code]int luaL_callmeta (lua_State *L, int obj, const char *e);[/code] [br]
##  [br]
##  Calls a metamethod.    [br]
##  If the object at index [code]obj[/code] has a metatable and this metatable has a field [code]e[/code], this function calls this field passing the object as its only argument. In this case this function returns true and pushes onto the stack the value returned by the call. If there is no metatable or no metamethod, this function returns false without pushing any value on the stack.       [br]
func luaL_callmeta(L: int, obj: int, event: int) -> Variant:
	return self.__luaL_callmeta.call_wasm_catch([L, obj, event])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_type: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_type (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns the type of the value in the given valid index, or [code]LUA_TNONE[/code] for a non-valid but acceptable index. The types returned by [method lua_type] are coded by the following constants defined in [code]lua.h[/code]: [code]LUA_TNIL[/code], [code]LUA_TNUMBER[/code], [code]LUA_TBOOLEAN[/code], [code]LUA_TSTRING[/code], [code]LUA_TTABLE[/code], [code]LUA_TFUNCTION[/code], [code]LUA_TUSERDATA[/code], [code]LUA_TTHREAD[/code], and [code]LUA_TLIGHTUSERDATA[/code].       [br]
func lua_type(L: int, idx: int) -> Variant:
	return self.__lua_type.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_typename: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]const char *lua_typename (lua_State *L, int tp);[/code] [br]
##  [br]
##  Returns the name of the type encoded by the value [code]tp[/code], which must be one the values returned by [method lua_type].       [br]
func lua_typename(L: int, t: int) -> Variant:
	return self.__lua_typename.call_wasm_catch([L, t])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __luaL_traceback: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]void luaL_traceback (lua_State *L, lua_State *L1, const char *msg,                      int level);[/code] [br]
##  [br]
##  Creates and pushes a traceback of the stack [code]L1[/code]. If [code]msg[/code] is not [code]NULL[/code], it is appended at the beginning of the traceback. The [code]level[/code] parameter tells at which level to start the traceback.       [br]
func luaL_traceback(L: int, L1: int, msg: int, level: int) -> Variant:
	return self.__luaL_traceback.call_wasm_catch([L, L1, msg, level])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __lua_sethook: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_sethook (lua_State *L, lua_Hook f, int mask, int count);[/code] [br]
##  [br]
##  Sets the debugging hook function.    [br]
##  Argument [code]f[/code] is the hook function. [code]mask[/code] specifies on which events the hook will be called: it is formed by a bitwise OR of the constants [code]LUA_MASKCALL[/code], [code]LUA_MASKRET[/code], [code]LUA_MASKLINE[/code], and [code]LUA_MASKCOUNT[/code]. The [code]count[/code] argument is only meaningful when the mask includes [code]LUA_MASKCOUNT[/code]. For each event, the hook is called as explained below:  The call hook:  is called when the interpreter calls a function. The hook is called just after Lua enters the new function. The return hook:  is called when the interpreter returns from a function. The hook is called just before Lua leaves the function. The line hook:  is called when the interpreter is about to start the execution of a new line of code, or when it jumps back in the code (even to the same line). This event only happens while Lua is executing a Lua function. The count hook:  is called after the interpreter executes every [code]count[/code] instructions. This event only happens while Lua is executing a Lua function.  [br]
##  Hooks are disabled by setting [code]mask[/code] to zero.       [br]
func lua_sethook(L: int, func_: int, mask: int, count: int) -> Variant:
	return self.__lua_sethook.call_wasm_catch([L, func_, mask, count])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_checkstack: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_checkstack (lua_State *L, int n);[/code] [br]
##  [br]
##  Ensures that the stack has space for at least [code]n[/code] extra elements, that is, that you can safely push up to [code]n[/code] values into it. It returns false if it cannot fulfill the request, either because it would cause the stack to be greater than a fixed maximum size (typically at least several thousand elements) or because it cannot allocate memory for the extra space. This function never shrinks the stack; if the stack already has space for the extra elements, it is left unchanged.       [br]
func lua_checkstack(L: int, n: int) -> Variant:
	return self.__lua_checkstack.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_xmove: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, –] [br]
## [code]void lua_xmove (lua_State *from, lua_State *to, int n);[/code] [br]
##  [br]
##  Exchange values between different threads of the same state.    [br]
##  This function pops [code]n[/code] values from the stack [code]from[/code], and pushes them onto the stack [code]to[/code].       [br]
func lua_xmove(from: int, to: int, n: int) -> Variant:
	return self.__lua_xmove.call_wasm_catch([from, to, n])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_atpanic: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_CFunction lua_atpanic (lua_State *L, lua_CFunction panicf);[/code] [br]
##  [br]
##  Sets a new panic function and returns the old one (see [code]§4.4[/code]).       [br]
func lua_atpanic(L: int, panicf: int) -> Variant:
	return self.__lua_atpanic.call_wasm_catch([L, panicf])

# ["func_type", ["i32"], ["f64"]]
var __lua_version: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_Number lua_version (lua_State *L);[/code] [br]
##  [br]
##  Returns the version number of this core.       [br]
func lua_version(L: int) -> Variant:
	return self.__lua_version.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_absindex: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_absindex (lua_State *L, int idx);[/code] [br]
##  [br]
##  Converts the acceptable index [code]idx[/code] into an equivalent absolute index (that is, one that does not depend on the stack size).       [br]
func lua_absindex(L: int, idx: int) -> Variant:
	return self.__lua_absindex.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], []]
var __lua_closeslot: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, e] [br]
## [code]void lua_closeslot (lua_State *L, int index);[/code] [br]
##  [br]
##  Close the to-be-closed slot at the given index and set its value to nil. The index must be the last index previously marked to be closed (see [method lua_toclose]) that is still active (that is, not closed yet).    [br]
##  A [code]__close[/code] metamethod cannot yield when called through this function.       [br]
func lua_closeslot(L: int, idx: int) -> Variant:
	return self.__lua_closeslot.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_copy: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_copy (lua_State *L, int fromidx, int toidx);[/code] [br]
##  [br]
##  Copies the element at index [code]fromidx[/code] into the valid index [code]toidx[/code], replacing the value at that position. Values at other positions are not affected.       [br]
func lua_copy(L: int, fromidx: int, toidx: int) -> Variant:
	return self.__lua_copy.call_wasm_catch([L, fromidx, toidx])

# ["func_type", ["i32", "i32"], []]
var __lua_pushvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]void lua_pushvalue (lua_State *L, int index);[/code] [br]
##  [br]
##  Pushes a copy of the element at the given index onto the stack.       [br]
func lua_pushvalue(L: int, idx: int) -> Variant:
	return self.__lua_pushvalue.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_iscfunction: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_iscfunction (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns 1 if the value at the given index is a C function, and 0 otherwise.       [br]
func lua_iscfunction(L: int, idx: int) -> Variant:
	return self.__lua_iscfunction.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_isinteger (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns 1 if the value at the given index is an integer (that is, the value is a number and is represented as an integer), and 0 otherwise.       [br]
func lua_isinteger(L: int, idx: int) -> Variant:
	return self.__lua_isinteger.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isnumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_isnumber (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns 1 if the value at the given index is a number or a string convertible to a number, and 0 otherwise.       [br]
func lua_isnumber(L: int, idx: int) -> Variant:
	return self.__lua_isnumber.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_isstring (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns 1 if the value at the given index is a string or a number (which is always convertible to a string), and 0 otherwise.       [br]
func lua_isstring(L: int, idx: int) -> Variant:
	return self.__lua_isstring.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_isuserdata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_isuserdata (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns 1 if the value at the given index is a userdata (either full or light), and 0 otherwise.       [br]
func lua_isuserdata(L: int, idx: int) -> Variant:
	return self.__lua_isuserdata.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_rawequal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_rawequal (lua_State *L, int index1, int index2);[/code] [br]
##  [br]
##  Returns 1 if the two values in indices [code]index1[/code] and [code]index2[/code] are primitively equal (that is, equal without calling the [code]__eq[/code] metamethod). Otherwise returns 0. Also returns 0 if any of the indices are not valid.       [br]
func lua_rawequal(L: int, index1: int, index2: int) -> Variant:
	return self.__lua_rawequal.call_wasm_catch([L, index1, index2])

# ["func_type", ["i32", "i32"], []]
var __lua_arith: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-(2|1), +1, e] [br]
## [code]void lua_arith (lua_State *L, int op);[/code] [br]
##  [br]
##  Performs an arithmetic or bitwise operation over the two values (or one, in the case of negations) at the top of the stack, with the value on the top being the second operand, pops these values, and pushes the result of the operation. The function follows the semantics of the corresponding Lua operator (that is, it may call metamethods).    [br]
##  The value of [code]op[/code] must be one of the following constants:  [code]LUA_OPADD[/code]:  performs addition ([code]+[/code])[code]LUA_OPSUB[/code]:  performs subtraction ([code]-[/code])[code]LUA_OPMUL[/code]:  performs multiplication ([code]*[/code])[code]LUA_OPDIV[/code]:  performs float division ([code]/[/code])[code]LUA_OPIDIV[/code]:  performs floor division ([code]//[/code])[code]LUA_OPMOD[/code]:  performs modulo ([code]%[/code])[code]LUA_OPPOW[/code]:  performs exponentiation ([code]^[/code])[code]LUA_OPUNM[/code]:  performs mathematical negation (unary [code]-[/code])[code]LUA_OPBNOT[/code]:  performs bitwise NOT ([code]~[/code])[code]LUA_OPBAND[/code]:  performs bitwise AND ([code]&[/code])[code]LUA_OPBOR[/code]:  performs bitwise OR ([code]|[/code])[code]LUA_OPBXOR[/code]:  performs bitwise exclusive OR ([code]~[/code])[code]LUA_OPSHL[/code]:  performs left shift ([code]<<[/code])[code]LUA_OPSHR[/code]:  performs right shift ([code]>>[/code])      [br]
func lua_arith(L: int, op: int) -> Variant:
	return self.__lua_arith.call_wasm_catch([L, op])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_compare: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, e] [br]
## [code]int lua_compare (lua_State *L, int index1, int index2, int op);[/code] [br]
##  [br]
##  Compares two Lua values. Returns 1 if the value at index [code]index1[/code] satisfies [code]op[/code] when compared with the value at index [code]index2[/code], following the semantics of the corresponding Lua operator (that is, it may call metamethods). Otherwise returns 0. Also returns 0 if any of the indices is not valid.    [br]
##  The value of [code]op[/code] must be one of the following constants:  [code]LUA_OPEQ[/code]:  compares for equality ([code]==[/code])[code]LUA_OPLT[/code]:  compares for less than ([code]<[/code])[code]LUA_OPLE[/code]:  compares for less or equal ([code]<=[/code])      [br]
func lua_compare(L: int, index1: int, index2: int, op: int) -> Variant:
	return self.__lua_compare.call_wasm_catch([L, index1, index2, op])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_numbertocstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]unsigned lua_numbertocstring (lua_State *L, int idx,                                         char *buff);[/code] [br]
##  [br]
##  Converts the number at acceptable index [code]idx[/code] to a string and puts the result in [code]buff[/code]. The buffer must have a size of at least [code]LUA_N2SBUFFSZ[/code] bytes. The conversion follows a non-specified format (see [code]§3.4.3[/code]). The function returns the number of bytes written to the buffer (including the final zero), or zero if the value at [code]idx[/code] is not a number.       [br]
func lua_numbertocstring(L: int, idx: int, buff: int) -> Variant:
	return self.__lua_numbertocstring.call_wasm_catch([L, idx, buff])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_stringtonumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]size_t lua_stringtonumber (lua_State *L, const char *s);[/code] [br]
##  [br]
##  Converts the zero-terminated string [code]s[/code] to a number, pushes that number into the stack, and returns the total size of the string, that is, its length plus one. The conversion can result in an integer or a float, according to the lexical conventions of Lua (see [code]§3.1[/code]). The string may have leading and trailing whitespaces and a sign. If the string is not a valid numeral, returns 0 and pushes nothing. (Note that the result can be used as a boolean, true if the conversion succeeds.)       [br]
func lua_stringtonumber(L: int, s: int) -> Variant:
	return self.__lua_stringtonumber.call_wasm_catch([L, s])

# ["func_type", ["i32", "i32", "i32"], ["f64"]]
var __lua_tonumberx: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_Number lua_tonumberx (lua_State *L, int index, int *isnum);[/code] [br]
##  [br]
##  Converts the Lua value at the given index to the C type [method lua_Number] (see [method lua_Number]). The Lua value must be a number or a string convertible to a number (see [code]§3.4.3[/code]); otherwise, [method lua_tonumberx] returns 0.    [br]
##  If [code]isnum[/code] is not [code]NULL[/code], its referent is assigned a boolean value that indicates whether the operation succeeded.       [br]
func lua_tonumberx(L: int, idx: int, pisnum: int) -> Variant:
	return self.__lua_tonumberx.call_wasm_catch([L, idx, pisnum])

# ["func_type", ["i32", "i32"], ["i64"]]
var __lua_rawlen: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_Unsigned lua_rawlen (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns the raw "length" of the value at the given index: for strings, this is the string length; for tables, this is the result of the length operator ('[code]#[/code]') with no metamethods; for userdata, this is the size of the block of memory allocated for the userdata. For other values, this call returns 0.       [br]
func lua_rawlen(L: int, idx: int) -> Variant:
	return self.__lua_rawlen.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_tocfunction: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_CFunction lua_tocfunction (lua_State *L, int index);[/code] [br]
##  [br]
##  Converts a value at the given index to a C function. That value must be a C function; otherwise, returns [code]NULL[/code].       [br]
func lua_tocfunction(L: int, idx: int) -> Variant:
	return self.__lua_tocfunction.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_tothread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_State *lua_tothread (lua_State *L, int index);[/code] [br]
##  [br]
##  Converts the value at the given index to a Lua thread (represented as [code]lua_State*[/code]). This value must be a thread; otherwise, the function returns [code]NULL[/code].       [br]
func lua_tothread(L: int, idx: int) -> Variant:
	return self.__lua_tothread.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_topointer: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]const void *lua_topointer (lua_State *L, int index);[/code] [br]
##  [br]
##  Converts the value at the given index to a generic C pointer ([code]void*[/code]). The value can be a userdata, a table, a thread, a string, or a function; otherwise, [code]lua_topointer[/code] returns [code]NULL[/code]. Different objects will give different pointers. There is no way to convert the pointer back to its original value.    [br]
##  Typically this function is used only for hashing and debug information.       [br]
func lua_topointer(L: int, idx: int) -> Variant:
	return self.__lua_topointer.call_wasm_catch([L, idx])

# ["func_type", ["i32"], []]
var __lua_pushnil: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]void lua_pushnil (lua_State *L);[/code] [br]
##  [br]
##  Pushes a nil value onto the stack.       [br]
func lua_pushnil(L: int) -> Variant:
	return self.__lua_pushnil.call_wasm_catch([L])

# ["func_type", ["i32", "f64"], []]
var __lua_pushnumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]void lua_pushnumber (lua_State *L, lua_Number n);[/code] [br]
##  [br]
##  Pushes a float with value [code]n[/code] onto the stack.       [br]
func lua_pushnumber(L: int, n: float) -> Variant:
	return self.__lua_pushnumber.call_wasm_catch([L, n])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __lua_pushexternalstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]const char *lua_pushexternalstring (lua_State *L,                 const char *s, size_t len, lua_Alloc falloc, void *ud);[/code] [br]
##  [br]
##  Creates an external string, that is, a string that uses memory not managed by Lua. The pointer [code]s[/code] points to the external buffer holding the string content, and [code]len[/code] is the length of the string. The string should have a zero at its end, that is, the condition [code]s[len] == '\0'[/code] should hold. As with any string in Lua, the length must fit in a Lua integer.    [br]
##  If [code]falloc[/code] is different from [code]NULL[/code], that function will be called by Lua when the external buffer is no longer needed. The contents of the buffer should not change before this call. The function will be called with the given [code]ud[/code], the string [code]s[/code] as the block, the length plus one (to account for the ending zero) as the old size, and 0 as the new size.    [br]
##  Even when using an external buffer, Lua still has to allocate a header for the string. In case of a memory-allocation error, Lua will call [code]falloc[/code] before raising the error.    [br]
##  The function returns a pointer to the string (that is, [code]s[/code]).       [br]
func lua_pushexternalstring(L: int, s: int, len: int, falloc: int, ud: int) -> Variant:
	return self.__lua_pushexternalstring.call_wasm_catch([L, s, len, falloc, ud])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_pushvfstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]const char *lua_pushvfstring (lua_State *L,                               const char *fmt,                               va_list argp);[/code] [br]
##  [br]
##  Equivalent to [method lua_pushfstring], except that it receives a [code]va_list[/code] instead of a variable number of arguments, and it does not raise errors. Instead, in case of errors it pushes the error message and returns [code]NULL[/code].       [br]
func lua_pushvfstring(L: int, fmt: int, argp: int) -> Variant:
	return self.__lua_pushvfstring.call_wasm_catch([L, fmt, argp])

# ["func_type", ["i32"], ["i32"]]
var __lua_pushthread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int lua_pushthread (lua_State *L);[/code] [br]
##  [br]
##  Pushes the thread represented by [code]L[/code] onto the stack. Returns 1 if this thread is the main thread of its state.       [br]
func lua_pushthread(L: int) -> Variant:
	return self.__lua_pushthread.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_gettable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +1, e] [br]
## [code]int lua_gettable (lua_State *L, int index);[/code] [br]
##  [br]
##  Pushes onto the stack the value [code]t[k][/code], where [code]t[/code] is the value at the given index and [code]k[/code] is the value on the top of the stack.    [br]
##  This function pops the key from the stack, pushing the resulting value in its place. As in Lua, this function may trigger a metamethod for the "index" event (see [code]§2.4[/code]).    [br]
##  Returns the type of the pushed value.       [br]
func lua_gettable(L: int, idx: int) -> Variant:
	return self.__lua_gettable.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getfield: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]int lua_getfield (lua_State *L, int index, const char *k);[/code] [br]
##  [br]
##  Pushes onto the stack the value [code]t[k][/code], where [code]t[/code] is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see [code]§2.4[/code]).    [br]
##  Returns the type of the pushed value.       [br]
func lua_getfield(L: int, idx: int, k: int) -> Variant:
	return self.__lua_getfield.call_wasm_catch([L, idx, k])

# ["func_type", ["i32", "i32", "i64"], ["i32"]]
var __lua_geti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]int lua_geti (lua_State *L, int index, lua_Integer i);[/code] [br]
##  [br]
##  Pushes onto the stack the value [code]t[i][/code], where [code]t[/code] is the value at the given index. As in Lua, this function may trigger a metamethod for the "index" event (see [code]§2.4[/code]).    [br]
##  Returns the type of the pushed value.       [br]
func lua_geti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_geti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_rawget: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +1, –] [br]
## [code]int lua_rawget (lua_State *L, int index);[/code] [br]
##  [br]
##  Similar to [method lua_gettable], but does a raw access (i.e., without metamethods). The value at [code]index[/code] must be a table.       [br]
func lua_rawget(L: int, idx: int) -> Variant:
	return self.__lua_rawget.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_rawgetp: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int lua_rawgetp (lua_State *L, int index, const void *p);[/code] [br]
##  [br]
##  Pushes onto the stack the value [code]t[k][/code], where [code]t[/code] is the table at the given index and [code]k[/code] is the pointer [code]p[/code] represented as a light userdata. The access is raw; that is, it does not use the [code]__index[/code] metavalue.    [br]
##  Returns the type of the pushed value.       [br]
func lua_rawgetp(L: int, idx: int, p: int) -> Variant:
	return self.__lua_rawgetp.call_wasm_catch([L, idx, p])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_getmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +(0|1), –] [br]
## [code]int lua_getmetatable (lua_State *L, int index);[/code] [br]
##  [br]
##  If the value at the given index has a metatable, the function pushes that metatable onto the stack and returns 1. Otherwise, the function returns 0 and pushes nothing on the stack.       [br]
func lua_getmetatable(L: int, objindex: int) -> Variant:
	return self.__lua_getmetatable.call_wasm_catch([L, objindex])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getiuservalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int lua_getiuservalue (lua_State *L, int index, int n);[/code] [br]
##  [br]
##  Pushes onto the stack the [code]n[/code]-th user value associated with the full userdata at the given index and returns the type of the pushed value.    [br]
##  If the userdata does not have that value, pushes nil and returns [code]LUA_TNONE[/code][/code].       [br]
func lua_getiuservalue(L: int, idx: int, n: int) -> Variant:
	return self.__lua_getiuservalue.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], []]
var __lua_settable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-2, +0, e] [br]
## [code]void lua_settable (lua_State *L, int index);[/code] [br]
##  [br]
##  Does the equivalent to [code]t[k] = v[/code], where [code]t[/code] is the value at the given index, [code]v[/code] is the value on the top of the stack, and [code]k[/code] is the value just below the top.    [br]
##  This function pops both the key and the value from the stack. As in Lua, this function may trigger a metamethod for the "newindex" event (see [code]§2.4[/code]).       [br]
func lua_settable(L: int, idx: int) -> Variant:
	return self.__lua_settable.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i64"], []]
var __lua_seti: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, e] [br]
## [code]void lua_seti (lua_State *L, int index, lua_Integer n);[/code] [br]
##  [br]
##  Does the equivalent to [code]t[n] = v[/code], where [code]t[/code] is the value at the given index and [code]v[/code] is the value on the top of the stack.    [br]
##  This function pops the value from the stack. As in Lua, this function may trigger a metamethod for the "newindex" event (see [code]§2.4[/code]).       [br]
func lua_seti(L: int, idx: int, n: int) -> Variant:
	return self.__lua_seti.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32"], []]
var __lua_rawset: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-2, +0, m] [br]
## [code]void lua_rawset (lua_State *L, int index);[/code] [br]
##  [br]
##  Similar to [method lua_settable], but does a raw assignment (i.e., without metamethods). The value at [code]index[/code] must be a table.       [br]
func lua_rawset(L: int, idx: int) -> Variant:
	return self.__lua_rawset.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_rawsetp: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, m] [br]
## [code]void lua_rawsetp (lua_State *L, int index, const void *p);[/code] [br]
##  [br]
##  Does the equivalent of [code]t[p] = v[/code], where [code]t[/code] is the table at the given index, [code]p[/code] is encoded as a light userdata, and [code]v[/code] is the value on the top of the stack.    [br]
##  This function pops the value from the stack. The assignment is raw, that is, it does not use the [code]__newindex[/code] metavalue.       [br]
func lua_rawsetp(L: int, idx: int, p: int) -> Variant:
	return self.__lua_rawsetp.call_wasm_catch([L, idx, p])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_setmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, –] [br]
## [code]int lua_setmetatable (lua_State *L, int index);[/code] [br]
##  [br]
##  Pops a table or nil from the stack and sets that value as the new metatable for the value at the given index. (nil means no metatable.)    [br]
##  (For historical reasons, this function returns an [code]int[/code], which now is always 1.)       [br]
func lua_setmetatable(L: int, objindex: int) -> Variant:
	return self.__lua_setmetatable.call_wasm_catch([L, objindex])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_setiuservalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, –] [br]
## [code]int lua_setiuservalue (lua_State *L, int index, int n);[/code] [br]
##  [br]
##  Pops a value from the stack and sets it as the new [code]n[/code]-th user value associated to the full userdata at the given index. Returns 0 if the userdata does not have that value.       [br]
func lua_setiuservalue(L: int, idx: int, n: int) -> Variant:
	return self.__lua_setiuservalue.call_wasm_catch([L, idx, n])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], []]
var __lua_callk: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-(nargs + 1), +nresults, e] [br]
## [code]void lua_callk (lua_State *L,                 int nargs,                 int nresults,                 lua_KContext ctx,                 lua_KFunction k);[/code] [br]
##  [br]
##  This function behaves exactly like [method lua_call], but allows the called function to yield (see [code]§4.5[/code]).       [br]
func lua_callk(L: int, nargs: int, nresults: int, ctx: int, k: int) -> Variant:
	return self.__lua_callk.call_wasm_catch([L, nargs, nresults, ctx, k])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], ["i32"]]
var __lua_load: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int lua_load (lua_State *L,               lua_Reader reader,               void *data,               const char *chunkname,               const char *mode);[/code] [br]
##  [br]
##  Loads a Lua chunk without running it. If there are no errors, [code]lua_load[/code] pushes the compiled chunk as a Lua function on top of the stack. Otherwise, it pushes an error message.    [br]
##  The [code]lua_load[/code] function uses a user-supplied [code]reader[/code] function to read the chunk (see [method lua_Reader]). The [code]data[/code] argument is an opaque value passed to the reader function.    [br]
##  The [code]chunkname[/code] argument gives a name to the chunk, which is used for error messages and in debug information (see [code]§4.7[/code]).    [br]
## [code]lua_load[/code] automatically detects whether the chunk is text or binary and loads it accordingly (see program [code]luac[/code]). The string [code]mode[/code] works as in function [code]load[/code][/code], with the addition that a [code]NULL[/code] value is equivalent to the string "[code]bt[/code]". Moreover, it may have a '[code]B[/code]' instead of a '[code]b[/code]', meaning a fixed buffer with the binary dump.    [br]
##  A fixed buffer means that the address returned by the reader function will contain the chunk until everything created by the chunk has been collected; therefore, Lua can avoid copying to internal structures some parts of the chunk. (In general, a fixed buffer would keep its contents until the end of the program, for instance with the chunk in ROM.) Moreover, for a fixed buffer, the reader function should return the entire chunk in the first read. (As an example, [method luaL_loadbufferx] does that, which means that you can use it to load fixed buffers.)    [br]
##  The function [method lua_load] fully preserves the Lua stack through the calls to the reader function, except that it may push some values for internal use before the first call, and it restores the stack size to its original size plus one (for the pushed result) after the last call.    [br]
## [code]lua_load[/code] can return [code]LUA_OK[/code][/code], [code]LUA_ERRSYNTAX[/code][/code], or [code]LUA_ERRMEM[/code][/code]. The function may also return other values corresponding to errors raised by the read function (see [code]§4.4.1[/code]).    [br]
##  If the resulting function has upvalues, its first upvalue is set to the value of the global environment stored at index [code]LUA_RIDX_GLOBALS[/code] in the registry (see [code]§4.3[/code]). When loading main chunks, this upvalue will be the [code]_ENV[/code] variable (see [code]§2.2[/code]). Other upvalues are initialized with nil.       [br]
func lua_load(L: int, reader: int, data: int, chunkname: int, mode: int) -> Variant:
	return self.__lua_load.call_wasm_catch([L, reader, data, chunkname, mode])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_dump: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_dump (lua_State *L,                         lua_Writer writer,                         void *data,                         int strip);[/code] [br]
##  [br]
##  Dumps a function as a binary chunk. Receives a Lua function on the top of the stack and produces a binary chunk that, if loaded again, results in a function equivalent to the one dumped. As it produces parts of the chunk, [method lua_dump] calls function [code]writer[/code] (see [method lua_Writer]) with the given [code]data[/code] to write them.    [br]
##  The function [method lua_dump] fully preserves the Lua stack through the calls to the writer function, except that it may push some values for internal use before the first call, and it restores the stack size to its original size after the last call.    [br]
##  If [code]strip[/code] is true, the binary representation may not include all debug information about the function, to save space.    [br]
##  The value returned is the error code returned by the last call to the writer; 0 means no errors.       [br]
func lua_dump(L: int, writer: int, data: int, strip: int) -> Variant:
	return self.__lua_dump.call_wasm_catch([L, writer, data, strip])

# ["func_type", ["i32"], ["i32"]]
var __lua_status: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_status (lua_State *L);[/code] [br]
##  [br]
##  Returns the status of the thread [code]L[/code].    [br]
##  The status can be [code]LUA_OK[/code][/code] for a normal thread, an error code if the thread finished the execution of a [method lua_resume] with an error, or [code]LUA_YIELD[/code][/code] if the thread is suspended.    [br]
##  You can call functions only in threads with status [code]LUA_OK[/code][/code]. You can resume threads with status [code]LUA_OK[/code][/code] (to start a new coroutine) or [code]LUA_YIELD[/code][/code] (to resume a coroutine).       [br]
func lua_status(L: int) -> Variant:
	return self.__lua_status.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __lua_error: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, v] [br]
## [code]int lua_error (lua_State *L);[/code] [br]
##  [br]
##  Raises a Lua error, using the value on the top of the stack as the error object. This function does a long jump, and therefore never returns (see [method luaL_error]).       [br]
func lua_error(L: int) -> Variant:
	return self.__lua_error.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_next: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +(2|0), v] [br]
## [code]int lua_next (lua_State *L, int index);[/code] [br]
##  [br]
##  Pops a key from the stack, and pushes a key–value pair from the table at the given index, the "next" pair after the given key. If there are no more elements in the table, then [method lua_next] returns 0 and pushes nothing.    [br]
##  A typical table traversal looks like this:  [code]      /* table is in the stack at index 't' */      lua_pushnil(L);  /* first key */      while (lua_next(L, t) != 0) {        /* uses 'key' (at index -2) and 'value' (at index -1) */        printf("%s - %s\n",               lua_typename(L, lua_type(L, -2)),               lua_typename(L, lua_type(L, -1)));        /* removes 'value'; keeps 'key' for next iteration */        lua_pop(L, 1);      } [/code] [br]
##  [br]
##  While traversing a table, avoid calling [method lua_tolstring] directly on a key, unless you know that the key is actually a string. Recall that [method lua_tolstring] may change the value at the given index; this confuses the next call to [method lua_next].    [br]
##  This function may raise an error if the given key is neither nil nor present in the table. See function [code]next[/code][/code] for the caveats of modifying the table during its traversal.       [br]
func lua_next(L: int, idx: int) -> Variant:
	return self.__lua_next.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], []]
var __lua_toclose: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]void lua_toclose (lua_State *L, int index);[/code] [br]
##  [br]
##  Marks the given index in the stack as a to-be-closed slot (see [code]§3.3.8[/code]). Like a to-be-closed variable in Lua, the value at that slot in the stack will be closed when it goes out of scope. Here, in the context of a C function, to go out of scope means that the running function returns to Lua, or there is an error, or the slot is removed from the stack through [method lua_settop] or [method lua_pop], or there is a call to [method lua_closeslot]. A slot marked as to-be-closed should not be removed from the stack by any other function in the API except [method lua_settop] or [method lua_pop], unless previously deactivated by [method lua_closeslot].    [br]
##  This function raises an error if the value at the given slot neither has a [code]__close[/code] metamethod nor is a false value.    [br]
##  This function should not be called for an index that is equal to or below an active to-be-closed slot.    [br]
##  Note that, both in case of errors and of a regular return, by the time the [code]__close[/code] metamethod runs, the C stack was already unwound, so that any automatic C variable declared in the calling function (e.g., a buffer) will be out of scope.       [br]
func lua_toclose(L: int, idx: int) -> Variant:
	return self.__lua_toclose.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], []]
var __lua_len: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]void lua_len (lua_State *L, int index);[/code] [br]
##  [br]
##  Returns the length of the value at the given index. It is equivalent to the '[code]#[/code]' operator in Lua (see [code]§3.4.7[/code]) and may trigger a metamethod for the "length" event (see [code]§2.4[/code]). The result is pushed on the stack.       [br]
func lua_len(L: int, idx: int) -> Variant:
	return self.__lua_len.call_wasm_catch([L, idx])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_getallocf: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_Alloc lua_getallocf (lua_State *L, void **ud);[/code] [br]
##  [br]
##  Returns the memory-allocator function of a given state. If [code]ud[/code] is not [code]NULL[/code], Lua stores in [code]*ud[/code] the opaque pointer given when the memory-allocator function was set.       [br]
func lua_getallocf(L: int, ud: int) -> Variant:
	return self.__lua_getallocf.call_wasm_catch([L, ud])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_setallocf: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);[/code] [br]
##  [br]
##  Changes the allocator function of a given state to [code]f[/code] with user data [code]ud[/code].       [br]
func lua_setallocf(L: int, f: int, ud: int) -> Variant:
	return self.__lua_setallocf.call_wasm_catch([L, f, ud])

# ["func_type", ["i32", "i32", "i32"], []]
var __lua_setwarnf: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_setwarnf (lua_State *L, lua_WarnFunction f, void *ud);[/code] [br]
##  [br]
##  Sets the warning function to be used by Lua to emit warnings (see [method lua_WarnFunction]). The [code]ud[/code] parameter sets the value [code]ud[/code] passed to the warning function.       [br]
func lua_setwarnf(L: int, f: int, ud: int) -> Variant:
	return self.__lua_setwarnf.call_wasm_catch([L, f, ud])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_newuserdatauv: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]void *lua_newuserdatauv (lua_State *L, size_t size, int nuvalue);[/code] [br]
##  [br]
##  This function creates and pushes on the stack a new full userdata, with [code]nuvalue[/code] associated Lua values, called [code]user values[/code], plus an associated block of raw memory with [code]size[/code] bytes. (The user values can be set and read with the functions [method lua_setiuservalue] and [method lua_getiuservalue].)    [br]
##  The function returns the address of the block of memory. Lua ensures that this address is valid as long as the corresponding userdata is alive (see [code]§2.5[/code]). Moreover, if the userdata is marked for finalization (see [code]§2.5.3[/code]), its address is valid at least until the call to its finalizer.       [br]
func lua_newuserdatauv(L: int, size: int, nuvalue: int) -> Variant:
	return self.__lua_newuserdatauv.call_wasm_catch([L, size, nuvalue])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getupvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +(0|1), –] [br]
## [code]const char *lua_getupvalue (lua_State *L, int funcindex, int n);[/code] [br]
##  [br]
##  Gets information about the [code]n[/code]-th upvalue of the closure at index [code]funcindex[/code]. It pushes the upvalue's value onto the stack and returns its name. Returns [code]NULL[/code] (and pushes nothing) when the index [code]n[/code] is greater than the number of upvalues.    [br]
##  See [code]debug.getupvalue[/code][/code] for more information about upvalues.       [br]
func lua_getupvalue(L: int, funcindex: int, n: int) -> Variant:
	return self.__lua_getupvalue.call_wasm_catch([L, funcindex, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_setupvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-(0|1), +0, –] [br]
## [code]const char *lua_setupvalue (lua_State *L, int funcindex, int n);[/code] [br]
##  [br]
##  Sets the value of a closure's upvalue. It assigns the value on the top of the stack to the upvalue and returns its name. It also pops the value from the stack.    [br]
##  Returns [code]NULL[/code] (and pops nothing) when the index [code]n[/code] is greater than the number of upvalues.    [br]
##  Parameters [code]funcindex[/code] and [code]n[/code] are as in the function [method lua_getupvalue].       [br]
func lua_setupvalue(L: int, funcindex: int, n: int) -> Variant:
	return self.__lua_setupvalue.call_wasm_catch([L, funcindex, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_upvalueid: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void *lua_upvalueid (lua_State *L, int funcindex, int n);[/code] [br]
##  [br]
##  Returns a unique identifier for the upvalue numbered [code]n[/code] from the closure at index [code]funcindex[/code].    [br]
##  These unique identifiers allow a program to check whether different closures share upvalues. Lua closures that share an upvalue (that is, that access a same external local variable) will return identical ids for those upvalue indices.    [br]
##  Parameters [code]funcindex[/code] and [code]n[/code] are as in the function [method lua_getupvalue], but [code]n[/code] cannot be greater than the number of upvalues.       [br]
func lua_upvalueid(L: int, fidx: int, n: int) -> Variant:
	return self.__lua_upvalueid.call_wasm_catch([L, fidx, n])

# ["func_type", ["i32", "i32", "i32", "i32", "i32"], []]
var __lua_upvaluejoin: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_upvaluejoin (lua_State *L, int funcindex1, int n1,                                     int funcindex2, int n2);[/code] [br]
##  [br]
##  Make the [code]n1[/code]-th upvalue of the Lua closure at index [code]funcindex1[/code] refer to the [code]n2[/code]-th upvalue of the Lua closure at index [code]funcindex2[/code].        5 – The Auxiliary Library     [br]
##   The auxiliary library provides several convenient functions to interface C with Lua. While the basic API provides the primitive functions for all interactions between C and Lua, the auxiliary library provides higher-level functions for some common tasks.    [br]
##  All functions and types from the auxiliary library are defined in the header file [code]lauxlib.h[/code] and have a prefix [code]luaL_[/code].    [br]
##  All functions in the auxiliary library are built on top of the basic API, and so they provide nothing that cannot be done with that API. Nevertheless, the use of the auxiliary library ensures more consistency to your code.    [br]
##  Several functions in the auxiliary library use internally some extra stack slots. When a function in the auxiliary library uses less than five slots, it does not check the stack size; it simply assumes that there are enough slots.    [br]
##  Several functions in the auxiliary library are used to check C function arguments. Because the error message is formatted for arguments (e.g., "[code]bad argument #1[/code]"), you should not use these functions for other stack values.    [br]
##  Functions called [code]luaL_check*[/code] always raise an error if the check is not satisfied.      5.1 – Functions and Types [br]
##  Here we list all functions and types from the auxiliary library in alphabetical order.     [br]
func lua_upvaluejoin(L: int, fidx1: int, n1: int, fidx2: int, n2: int) -> Variant:
	return self.__lua_upvaluejoin.call_wasm_catch([L, fidx1, n1, fidx2, n2])

# ["func_type", ["i32"], ["i32"]]
var __lua_gethook: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_Hook lua_gethook (lua_State *L);[/code] [br]
##  [br]
##  Returns the current hook function.       [br]
func lua_gethook(L: int) -> Variant:
	return self.__lua_gethook.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __lua_gethookmask: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_gethookmask (lua_State *L);[/code] [br]
##  [br]
##  Returns the current hook mask.       [br]
func lua_gethookmask(L: int) -> Variant:
	return self.__lua_gethookmask.call_wasm_catch([L])

# ["func_type", ["i32"], ["i32"]]
var __lua_gethookcount: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_gethookcount (lua_State *L);[/code] [br]
##  [br]
##  Returns the current hook count.       [br]
func lua_gethookcount(L: int) -> Variant:
	return self.__lua_gethookcount.call_wasm_catch([L])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getstack: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_getstack (lua_State *L, int level, lua_Debug *ar);[/code] [br]
##  [br]
##  Gets information about the interpreter runtime stack.    [br]
##  This function fills parts of a [method lua_Debug] structure with an identification of the activation record of the function executing at a given level. Level 0 is the current running function, whereas level n+1 is the function that has called level n (except for tail calls, which do not count in the stack). When called with a level greater than the stack depth, [method lua_getstack] returns 0; otherwise it returns 1.       [br]
func lua_getstack(L: int, level: int, ar: int) -> Variant:
	return self.__lua_getstack.call_wasm_catch([L, level, ar])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getlocal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +(0|1), –] [br]
## [code]const char *lua_getlocal (lua_State *L, const lua_Debug *ar, int n);[/code] [br]
##  [br]
##  Gets information about a local variable or a temporary value of a given activation record or a given function.    [br]
##  In the first case, the parameter [code]ar[/code] must be a valid activation record that was filled by a previous call to [method lua_getstack] or given as argument to a hook (see [method lua_Hook]). The index [code]n[/code] selects which local variable to inspect; see [code]debug.getlocal[/code][/code] for details about variable indices and names.    [br]
## [method lua_getlocal] pushes the variable's value onto the stack and returns its name.    [br]
##  In the second case, [code]ar[/code] must be [code]NULL[/code] and the function to be inspected must be on the top of the stack. In this case, only parameters of Lua functions are visible (as there is no information about what variables are active) and no values are pushed onto the stack.    [br]
##  Returns [code]NULL[/code] (and pushes nothing) when the index is greater than the number of active local variables.       [br]
func lua_getlocal(L: int, ar: int, n: int) -> Variant:
	return self.__lua_getlocal.call_wasm_catch([L, ar, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_setlocal: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-(0|1), +0, –] [br]
## [code]const char *lua_setlocal (lua_State *L, const lua_Debug *ar, int n);[/code] [br]
##  [br]
##  Sets the value of a local variable of a given activation record. It assigns the value on the top of the stack to the variable and returns its name. It also pops the value from the stack.    [br]
##  Returns [code]NULL[/code] (and pops nothing) when the index is greater than the number of active local variables.    [br]
##  Parameters [code]ar[/code] and [code]n[/code] are as in the function [method lua_getlocal].       [br]
func lua_setlocal(L: int, ar: int, n: int) -> Variant:
	return self.__lua_setlocal.call_wasm_catch([L, ar, n])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_getinfo: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-(0|1), +(0|1|2), m] [br]
## [code]int lua_getinfo (lua_State *L, const char *what, lua_Debug *ar);[/code] [br]
##  [br]
##  Gets information about a specific function or function invocation.    [br]
##  To get information about a function invocation, the parameter [code]ar[/code] must be a valid activation record that was filled by a previous call to [method lua_getstack] or given as argument to a hook (see [method lua_Hook]).    [br]
##  To get information about a function, you push it onto the stack and start the [code]what[/code] string with the character '[code]>[/code]'. (In that case, [code]lua_getinfo[/code] pops the function from the top of the stack.) For instance, to know in which line a function [code]f[/code] was defined, you can write the following code:  [code]      lua_Debug ar;      lua_getglobal(L, "f");  /* get global 'f' */      lua_getinfo(L, ">S", &ar);      printf("%d\n", ar.linedefined); [/code] [br]
##  [br]
##  Each character in the string [code]what[/code] selects some fields of the structure [code]ar[/code] to be filled or a value to be pushed on the stack. (These characters are also documented in the declaration of the structure [method lua_Debug], between parentheses in the comments following each field.)  '[code]f[/code]':  pushes onto the stack the function that is running at the given level; '[code]l[/code]':  fills in the field [code]currentline[/code]; '[code]n[/code]':  fills in the fields [code]name[/code] and [code]namewhat[/code]; '[code]r[/code]':  fills in the fields [code]ftransfer[/code] and [code]ntransfer[/code]; '[code]S[/code]':  fills in the fields [code]source[/code], [code]short_src[/code], [code]linedefined[/code], [code]lastlinedefined[/code], and [code]what[/code]; '[code]t[/code]':  fills in the fields [code]istailcall[/code] and [code]extraargs[/code]; '[code]u[/code]':  fills in the fields [code]nups[/code], [code]nparams[/code], and [code]isvararg[/code]; '[code]L[/code]':  pushes onto the stack a table whose indices are the lines on the function with some associated code, that is, the lines where you can put a break point. (Lines with no code include empty lines and comments.) If this option is given together with option '[code]f[/code]', its table is pushed after the function. This is the only option that can raise a memory error.  [br]
##  This function returns 0 to signal an invalid option in [code]what[/code]; even then the valid options are handled correctly.       [br]
func lua_getinfo(L: int, what: int, ar: int) -> Variant:
	return self.__lua_getinfo.call_wasm_catch([L, what, ar])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_resume: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, –] [br]
## [code]int lua_resume (lua_State *L, lua_State *from, int nargs,                           int *nresults);[/code] [br]
##  [br]
##  Starts and resumes a coroutine in the given thread [code]L[/code].    [br]
##  To start a coroutine, you push the main function plus any arguments onto the empty stack of the thread. then you call [method lua_resume], with [code]nargs[/code] being the number of arguments. The function returns when the coroutine suspends, finishes its execution, or raises an unprotected error. When it returns without errors, [code]*nresults[/code] is updated and the top of the stack contains the [code]*nresults[/code] values passed to [method lua_yield] or returned by the body function. [method lua_resume] returns [code]LUA_YIELD[/code][/code] if the coroutine yields, [code]LUA_OK[/code][/code] if the coroutine finishes its execution without errors, or an error code in case of errors (see [code]§4.4.1[/code]). In case of errors, the error object is pushed on the top of the stack. (In that case, [code]nresults[/code] is not updated, as its value would have to be 1 for the sole error object.)    [br]
##  To resume a suspended coroutine, you remove the [code]*nresults[/code] yielded values from its stack, push the values to be passed as results from [code]yield[/code], and then call [method lua_resume].    [br]
##  The parameter [code]from[/code] represents the coroutine that is resuming [code]L[/code]. If there is no such coroutine, this parameter can be [code]NULL[/code].       [br]
func lua_resume(L: int, from: int, nargs: int, nresults: int) -> Variant:
	return self.__lua_resume.call_wasm_catch([L, from, nargs, nresults])

# ["func_type", ["i32"], ["i32"]]
var __lua_isyieldable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]int lua_isyieldable (lua_State *L);[/code] [br]
##  [br]
##  Returns 1 if the given coroutine can yield, and 0 otherwise.       [br]
func lua_isyieldable(L: int) -> Variant:
	return self.__lua_isyieldable.call_wasm_catch([L])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __lua_yieldk: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, v] [br]
## [code]int lua_yieldk (lua_State *L,                 int nresults,                 lua_KContext ctx,                 lua_KFunction k);[/code] [br]
##  [br]
##  Yields a coroutine (thread).    [br]
##  When a C function calls [method lua_yieldk], the running coroutine suspends its execution, and the call to [method lua_resume] that started this coroutine returns. The parameter [code]nresults[/code] is the number of values from the stack that will be passed as results to [method lua_resume].    [br]
##  When the coroutine is resumed again, Lua calls the given continuation function [code]k[/code] to continue the execution of the C function that yielded (see [code]§4.5[/code]). This continuation function receives the same stack from the previous function, with the [code]n[/code] results removed and replaced by the arguments passed to [method lua_resume]. Moreover, the continuation function receives the value [code]ctx[/code] that was passed to [method lua_yieldk].    [br]
##  Usually, this function does not return; when the coroutine eventually resumes, it continues executing the continuation function. However, there is one special case, which is when this function is called from inside a line or a count hook (see [code]§4.7[/code]). In that case, [code]lua_yieldk[/code] should be called with no continuation (probably in the form of [method lua_yield]) and no results, and the hook should return immediately after the call. Lua will yield and, when the coroutine resumes again, it will continue the normal execution of the (Lua) function that triggered the hook.    [br]
##  This function can raise an error if it is called from a thread with a pending C call with no continuation function (what is called a C-call boundary), or it is called from a thread that is not running inside a resume (typically the main thread).        4.7 – The Debug Interface [br]
##  Lua has no built-in debugging facilities. Instead, it offers a special interface by means of functions and hooks. This interface allows the construction of different kinds of debuggers, profilers, and other tools that need "inside information" from the interpreter.     [br]
func lua_yieldk(L: int, nresults: int, ctx: int, k: int) -> Variant:
	return self.__lua_yieldk.call_wasm_catch([L, nresults, ctx, k])

# ["func_type", ["i32"], ["i32"]]
var __lua_newthread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]lua_State *lua_newthread (lua_State *L);[/code] [br]
##  [br]
##  Creates a new thread, pushes it on the stack, and returns a pointer to a [method lua_State] that represents this new thread. The new thread returned by this function shares with the original thread its global environment, but has an independent execution stack.    [br]
##  Threads are subject to garbage collection, like any Lua object.       [br]
func lua_newthread(L: int) -> Variant:
	return self.__lua_newthread.call_wasm_catch([L])

# ["func_type", ["i32", "i32"], ["i32"]]
var __lua_closethread: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +?, –] [br]
## [code]int lua_closethread (lua_State *L, lua_State *from);[/code] [br]
##  [br]
##  Resets a thread, cleaning its call stack and closing all pending to-be-closed variables. The parameter [code]from[/code] represents the coroutine that is resetting [code]L[/code]. If there is no such coroutine, this parameter can be [code]NULL[/code].    [br]
##  Unless [code]L[/code] is equal to [code]from[/code], the call returns a status code: [code]LUA_OK[/code][/code] for no errors in the thread (either the original error that stopped the thread or errors in closing methods), or an error status otherwise. In case of error, the error object is put on the top of the stack.    [br]
##  If [code]L[/code] is equal to [code]from[/code], it corresponds to a thread closing itself. In that case, the call does not return; instead, the resume that (re)started the thread returns. The thread must be running inside a resume.       [br]
func lua_closethread(L: int, from: int) -> Variant:
	return self.__lua_closethread.call_wasm_catch([L, from])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __lua_newstate: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]lua_State *lua_newstate (lua_Alloc f, void *ud,                                    unsigned int seed);[/code] [br]
##  [br]
##  Creates a new independent state and returns its main thread. Returns [code]NULL[/code] if it cannot create the state (due to lack of memory). The argument [code]f[/code] is the allocator function; Lua will do all memory allocation for this state through this function (see [method lua_Alloc]). The second argument, [code]ud[/code], is an opaque pointer that Lua passes to the allocator in every call. The third argument, [code]seed[/code], is a seed for the hashing of strings.       [br]
func lua_newstate(f: int, ud: int, seed: int) -> Variant:
	return self.__lua_newstate.call_wasm_catch([f, ud, seed])

# ["func_type", ["i32"], []]
var __lua_close: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void lua_close (lua_State *L);[/code] [br]
##  [br]
##  Close all active to-be-closed variables in the main thread, release all objects in the given Lua state (calling the corresponding garbage-collection metamethods, if any), and frees all dynamic memory used by this state.    [br]
##  On several platforms, you may not need to call this function, because all resources are naturally released when the host program ends. On the other hand, long-running programs that create multiple states, such as daemons or web servers, will probably need to close states as soon as they are not needed.       [br]
func lua_close(L: int) -> Variant:
	return self.__lua_close.call_wasm_catch([L])

# ["func_type", ["i32"], []]
var __luaL_pushresult: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +1, m] [br]
## [code]void luaL_pushresult (luaL_Buffer *B);[/code] [br]
##  [br]
##  Finishes the use of buffer [code]B[/code] leaving the final string on the top of the stack.       [br]
func luaL_pushresult(B: int) -> Variant:
	return self.__luaL_pushresult.call_wasm_catch([B])

# ["func_type", ["i32", "i32"], []]
var __luaL_buffinit: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +?, –] [br]
## [code]void luaL_buffinit (lua_State *L, luaL_Buffer *B);[/code] [br]
##  [br]
##  Initializes a buffer [code]B[/code] (see [method luaL_Buffer]). This function does not allocate any space; the buffer must be declared as a variable.       [br]
func luaL_buffinit(L: int, B: int) -> Variant:
	return self.__luaL_buffinit.call_wasm_catch([L, B])

# ["func_type", ["i32", "i32"], []]
var __luaL_addstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, m] [br]
## [code]void luaL_addstring (luaL_Buffer *B, const char *s);[/code] [br]
##  [br]
##  Adds the zero-terminated string pointed to by [code]s[/code] to the buffer [code]B[/code] (see [method luaL_Buffer]).       [br]
func luaL_addstring(B: int, s: int) -> Variant:
	return self.__luaL_addstring.call_wasm_catch([B, s])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_prepbuffsize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, m] [br]
## [code]char *luaL_prepbuffsize (luaL_Buffer *B, size_t sz);[/code] [br]
##  [br]
##  Returns an address to a space of size [code]sz[/code] where you can copy a string to be added to buffer [code]B[/code] (see [method luaL_Buffer]). After copying the string into this space you must call [method luaL_addsize] with the size of the string to actually add it to the buffer.       [br]
func luaL_prepbuffsize(B: int, sz: int) -> Variant:
	return self.__luaL_prepbuffsize.call_wasm_catch([B, sz])

# ["func_type", ["i32"], []]
var __luaL_addvalue: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, m] [br]
## [code]void luaL_addvalue (luaL_Buffer *B);[/code] [br]
##  [br]
##  Adds the value on the top of the stack to the buffer [code]B[/code] (see [method luaL_Buffer]). Pops the value.    [br]
##  This is the only function on string buffers that can (and must) be called with an extra element on the stack, which is the value to be added to the buffer.       [br]
func luaL_addvalue(B: int) -> Variant:
	return self.__luaL_addvalue.call_wasm_catch([B])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_argerror: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]int luaL_argerror (lua_State *L, int arg, const char *extramsg);[/code] [br]
##  [br]
##  Raises an error reporting a problem with argument [code]arg[/code] of the C function that called it, using a standard message that includes [code]extramsg[/code] as a comment:  [code]      bad argument #arg to 'funcname' (extramsg) [/code] [br]
##  [br]
##  This function never returns.       [br]
func luaL_argerror(L: int, arg: int, extramsg: int) -> Variant:
	return self.__luaL_argerror.call_wasm_catch([L, arg, extramsg])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_typeerror: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]int luaL_typeerror (lua_State *L, int arg, const char *tname);[/code] [br]
##  [br]
##  Raises a type error for the argument [code]arg[/code] of the C function that called it, using a standard message; [code]tname[/code] is a "name" for the expected type. This function never returns.       [br]
func luaL_typeerror(L: int, arg: int, tname: int) -> Variant:
	return self.__luaL_typeerror.call_wasm_catch([L, arg, tname])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_getmetafield: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +(0|1), m] [br]
## [code]int luaL_getmetafield (lua_State *L, int obj, const char *e);[/code] [br]
##  [br]
##  Pushes onto the stack the field [code]e[/code] from the metatable of the object at index [code]obj[/code] and returns the type of the pushed value. If the object does not have a metatable, or if the metatable does not have this field, pushes nothing and returns [code]LUA_TNIL[/code].       [br]
func luaL_getmetafield(L: int, obj: int, event: int) -> Variant:
	return self.__luaL_getmetafield.call_wasm_catch([L, obj, event])

# ["func_type", ["i32", "i32"], []]
var __luaL_where: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]void luaL_where (lua_State *L, int lvl);[/code] [br]
##  [br]
##  Pushes onto the stack a string identifying the current position of the control at level [code]lvl[/code] in the call stack. Typically this string has the following format:  [code]      chunkname:currentline: [/code] [br]
##  [br]
##  Level 0 is the running function, level 1 is the function that called the running function, etc.    [br]
##  This function is used to build a prefix for error messages.        6 – The Standard Libraries     [br]
##  The standard Lua libraries provide useful functions that are implemented in C through the C API. Some of these functions provide essential services to the language (e.g., [code]type[/code][/code] and [code]getmetatable[/code][/code]); others provide access to outside services (e.g., I/O); and others could be implemented in Lua itself, but that for different reasons deserve an implementation in C (e.g., [code]table.sort[/code][/code]).    [br]
##  All libraries are implemented through the official C API and are provided as separate C modules. Unless otherwise noted, these library functions do not adjust its number of arguments to its expected parameters. For instance, a function documented as [code]foo(arg)[/code] should not be called without an argument.    [br]
##  The notation fail means a false value representing some kind of failure. (Currently, fail is equal to nil, but that may change in future versions. The recommendation is to always test the success of these functions with [code](not status)[/code], instead of [code](status == nil)[/code].)    [br]
##  Currently, Lua has the following standard libraries:  basic library ([code]§6.2[/code]);coroutine library ([code]§6.3[/code]);package library ([code]§6.4[/code]);string manipulation ([code]§6.5[/code]);basic UTF-8 support ([code]§6.6[/code]);table manipulation ([code]§6.7[/code]);mathematical functions ([code]§6.8[/code]) (sin, log, etc.);input and output ([code]§6.9[/code]);operating system facilities ([code]§6.10[/code]);debug facilities ([code]§6.11[/code]). [br]
##  Except for the basic and the package libraries, each library provides all its functions as fields of a global table or as methods of its objects.      6.1 – Loading the Libraries in C code [br]
##  A C host program must explicitly load the standard libraries into a state, if it wants its scripts to use them. For that, the host program can call the function [method luaL_openlibs]. Alternatively, the host can select which libraries to open, by using [method luaL_openselectedlibs]. Both functions are declared in the header file [code]lualib.h[/code].     [br]
##  The stand-alone interpreter [code]lua[/code] (see [code]§7[/code]) already opens all standard libraries.     [br]
func luaL_where(L: int, level: int) -> Variant:
	return self.__luaL_where.call_wasm_catch([L, level])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_fileresult: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +(1|3), m] [br]
## [code]int luaL_fileresult (lua_State *L, int stat, const char *fname);[/code] [br]
##  [br]
##  This function produces the return values for file-related functions in the standard library ([code]io.open[/code][/code], [code]os.rename[/code][/code], [code]file:seek[/code][/code], etc.).       [br]
func luaL_fileresult(L: int, stat: int, fname: int) -> Variant:
	return self.__luaL_fileresult.call_wasm_catch([L, stat, fname])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_execresult: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +3, m] [br]
## [code]int luaL_execresult (lua_State *L, int stat);[/code] [br]
##  [br]
##  This function produces the return values for process-related functions in the standard library ([code]os.execute[/code][/code] and [code]io.close[/code][/code]).       [br]
func luaL_execresult(L: int, stat: int) -> Variant:
	return self.__luaL_execresult.call_wasm_catch([L, stat])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_newmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]int luaL_newmetatable (lua_State *L, const char *tname);[/code] [br]
##  [br]
##  If the registry already has the key [code]tname[/code], returns 0. Otherwise, creates a new table to be used as a metatable for userdata, adds to this new table the pair [code]__name = tname[/code], adds to the registry the pair [code][tname] = new table[/code], and returns 1.    [br]
##  In both cases, the function pushes onto the stack the final value associated with [code]tname[/code] in the registry.       [br]
func luaL_newmetatable(L: int, tname: int) -> Variant:
	return self.__luaL_newmetatable.call_wasm_catch([L, tname])

# ["func_type", ["i32", "i32"], []]
var __luaL_setmetatable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void luaL_setmetatable (lua_State *L, const char *tname);[/code] [br]
##  [br]
##  Sets the metatable of the object on the top of the stack as the metatable associated with name [code]tname[/code] in the registry (see [method luaL_newmetatable]).       [br]
func luaL_setmetatable(L: int, tname: int) -> Variant:
	return self.__luaL_setmetatable.call_wasm_catch([L, tname])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_testudata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, m] [br]
## [code]void *luaL_testudata (lua_State *L, int arg, const char *tname);[/code] [br]
##  [br]
##  This function works like [method luaL_checkudata], except that, when the test fails, it returns [code]NULL[/code] instead of raising an error.       [br]
func luaL_testudata(L: int, ud: int, tname: int) -> Variant:
	return self.__luaL_testudata.call_wasm_catch([L, ud, tname])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_checkudata: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]void *luaL_checkudata (lua_State *L, int arg, const char *tname);[/code] [br]
##  [br]
##  Checks whether the function argument [code]arg[/code] is a userdata of the type [code]tname[/code] (see [method luaL_newmetatable]) and returns the userdata's memory-block address (see [method lua_touserdata]).       [br]
func luaL_checkudata(L: int, ud: int, tname: int) -> Variant:
	return self.__luaL_checkudata.call_wasm_catch([L, ud, tname])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_checkoption: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]int luaL_checkoption (lua_State *L,                       int arg,                       const char *def,                       const char *const lst[]);[/code] [br]
##  [br]
##  Checks whether the function argument [code]arg[/code] is a string and searches for this string in the array [code]lst[/code] (which must be NULL-terminated). Returns the index in the array where the string was found. Raises an error if the argument is not a string or if the string cannot be found.    [br]
##  If [code]def[/code] is not [code]NULL[/code], the function uses [code]def[/code] as a default value when there is no argument [code]arg[/code] or when this argument is nil.    [br]
##  This is a useful function for mapping strings to C enums. (The usual convention in Lua libraries is to use strings instead of numbers to select options.)       [br]
func luaL_checkoption(L: int, arg: int, def: int, lst: int) -> Variant:
	return self.__luaL_checkoption.call_wasm_catch([L, arg, def, lst])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_optlstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]const char *luaL_optlstring (lua_State *L,                              int arg,                              const char *d,                              size_t *l);[/code] [br]
##  [br]
##  If the function argument [code]arg[/code] is a string, returns this string. If this argument is absent or is nil, returns [code]d[/code]. Otherwise, raises an error.    [br]
##  If [code]l[/code] is not [code]NULL[/code], fills its referent with the result's length. If the result is [code]NULL[/code] (only possible when returning [code]d[/code] and [code]d == NULL[/code]), its length is considered zero.    [br]
##  This function uses [method lua_tolstring] to get its result, so all conversions and caveats of that function apply here.       [br]
func luaL_optlstring(L: int, arg: int, def: int, len: int) -> Variant:
	return self.__luaL_optlstring.call_wasm_catch([L, arg, def, len])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_checklstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]const char *luaL_checklstring (lua_State *L, int arg, size_t *l);[/code] [br]
##  [br]
##  Checks whether the function argument [code]arg[/code] is a string and returns this string; if [code]l[/code] is not [code]NULL[/code] fills its referent with the string's length.    [br]
##  This function uses [method lua_tolstring] to get its result, so all conversions and caveats of that function apply here.       [br]
func luaL_checklstring(L: int, arg: int, len: int) -> Variant:
	return self.__luaL_checklstring.call_wasm_catch([L, arg, len])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_checktype: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]void luaL_checktype (lua_State *L, int arg, int t);[/code] [br]
##  [br]
##  Checks whether the function argument [code]arg[/code] has type [code]t[/code]. See [method lua_type] for the encoding of types for [code]t[/code].       [br]
func luaL_checktype(L: int, arg: int, t: int) -> Variant:
	return self.__luaL_checktype.call_wasm_catch([L, arg, t])

# ["func_type", ["i32", "i32"], []]
var __luaL_checkany: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]void luaL_checkany (lua_State *L, int arg);[/code] [br]
##  [br]
##  Checks whether the function has an argument of any type (including nil) at position [code]arg[/code].       [br]
func luaL_checkany(L: int, arg: int) -> Variant:
	return self.__luaL_checkany.call_wasm_catch([L, arg])

# ["func_type", ["i32", "i32"], ["f64"]]
var __luaL_checknumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]lua_Number luaL_checknumber (lua_State *L, int arg);[/code] [br]
##  [br]
##  Checks whether the function argument [code]arg[/code] is a number and returns this number converted to a [code]lua_Number[/code].       [br]
func luaL_checknumber(L: int, arg: int) -> Variant:
	return self.__luaL_checknumber.call_wasm_catch([L, arg])

# ["func_type", ["i32", "i32", "f64"], ["f64"]]
var __luaL_optnumber: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]lua_Number luaL_optnumber (lua_State *L, int arg, lua_Number d);[/code] [br]
##  [br]
##  If the function argument [code]arg[/code] is a number, returns this number as a [code]lua_Number[/code]. If this argument is absent or is nil, returns [code]d[/code]. Otherwise, raises an error.       [br]
func luaL_optnumber(L: int, arg: int, def: float) -> Variant:
	return self.__luaL_optnumber.call_wasm_catch([L, arg, def])

# ["func_type", ["i32", "i32"], ["i64"]]
var __luaL_checkinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]lua_Integer luaL_checkinteger (lua_State *L, int arg);[/code] [br]
##  [br]
##  Checks whether the function argument [code]arg[/code] is an integer (or can be converted to an integer) and returns this integer.       [br]
func luaL_checkinteger(L: int, arg: int) -> Variant:
	return self.__luaL_checkinteger.call_wasm_catch([L, arg])

# ["func_type", ["i32", "i32", "i64"], ["i64"]]
var __luaL_optinteger: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, v] [br]
## [code]lua_Integer luaL_optinteger (lua_State *L,                              int arg,                              lua_Integer d);[/code] [br]
##  [br]
##  If the function argument [code]arg[/code] is an integer (or it is convertible to an integer), returns this integer. If this argument is absent or is nil, returns [code]d[/code]. Otherwise, raises an error.       [br]
func luaL_optinteger(L: int, arg: int, def: int) -> Variant:
	return self.__luaL_optinteger.call_wasm_catch([L, arg, def])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_setfuncs: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-nup, +0, m] [br]
## [code]void luaL_setfuncs (lua_State *L, const luaL_Reg *l, int nup);[/code] [br]
##  [br]
##  Registers all functions in the array [code]l[/code] (see [method luaL_Reg]) into the table on the top of the stack (below optional upvalues, see next).    [br]
##  When [code]nup[/code] is not zero, all functions are created with [code]nup[/code] upvalues, initialized with copies of the [code]nup[/code] values previously pushed on the stack on top of the library table. These values are popped from the stack after the registration.    [br]
##  A function with a [code]NULL[/code] value represents a placeholder, which is filled with false.       [br]
func luaL_setfuncs(L: int, l: int, nup: int) -> Variant:
	return self.__luaL_setfuncs.call_wasm_catch([L, l, nup])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_addlstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, m] [br]
## [code]void luaL_addlstring (luaL_Buffer *B, const char *s, size_t l);[/code] [br]
##  [br]
##  Adds the string pointed to by [code]s[/code] with length [code]l[/code] to the buffer [code]B[/code] (see [method luaL_Buffer]). The string can contain embedded zeros.       [br]
func luaL_addlstring(B: int, s: int, l: int) -> Variant:
	return self.__luaL_addlstring.call_wasm_catch([B, s, l])

# ["func_type", ["i32", "i32"], []]
var __luaL_pushresultsize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +1, m] [br]
## [code]void luaL_pushresultsize (luaL_Buffer *B, size_t sz);[/code] [br]
##  [br]
##  Equivalent to the sequence [method luaL_addsize], [method luaL_pushresult].       [br]
func luaL_pushresultsize(B: int, sz: int) -> Variant:
	return self.__luaL_pushresultsize.call_wasm_catch([B, sz])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_buffinitsize: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, m] [br]
## [code]char *luaL_buffinitsize (lua_State *L, luaL_Buffer *B, size_t sz);[/code] [br]
##  [br]
##  Equivalent to the sequence [method luaL_buffinit], [method luaL_prepbuffsize].       [br]
func luaL_buffinitsize(L: int, B: int, sz: int) -> Variant:
	return self.__luaL_buffinitsize.call_wasm_catch([L, B, sz])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_ref: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-1, +0, m] [br]
## [code]int luaL_ref (lua_State *L, int t);[/code] [br]
##  [br]
##  Creates and returns a reference, in the table at index [code]t[/code], for the object on the top of the stack (and pops the object).    [br]
##  The reference system uses the integer keys of the table. A reference is a unique integer key; [method luaL_ref] ensures the uniqueness of the keys it returns. The entry 1 is reserved for internal use. Before the first use of [method luaL_ref], the integer keys of the table should form a proper sequence (no holes), and the value at entry 1 should be false: nil if the sequence is empty, false otherwise. You should not manually set integer keys in the table after the first use of [method luaL_ref].    [br]
##  You can retrieve an object referred by the reference [code]r[/code] by calling [code]lua_rawgeti(L,t,r)[/code] or [code]lua_geti(L,t,r)[/code]. The function [method luaL_unref] frees a reference.    [br]
##  If the object on the top of the stack is nil, [method luaL_ref] returns the constant [code]LUA_REFNIL[/code]. The constant [code]LUA_NOREF[/code] is guaranteed to be different from any reference returned by [method luaL_ref].       [br]
func luaL_ref(L: int, t: int) -> Variant:
	return self.__luaL_ref.call_wasm_catch([L, t])

# ["func_type", ["i32", "i32", "i32"], []]
var __luaL_unref: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]void luaL_unref (lua_State *L, int t, int ref);[/code] [br]
##  [br]
##  Releases a reference (see [method luaL_ref]). The integer [code]ref[/code] must be either [code]LUA_NOREF[/code][/code], [code]LUA_REFNIL[/code][/code], or a reference previously returned by [method luaL_ref] and not already released. If [code]ref[/code] is either [code]LUA_NOREF[/code][/code] or [code]LUA_REFNIL[/code][/code] this function does nothing. Otherwise, the entry is removed from the table, so that the referred object can be collected and the reference [code]ref[/code] can be used again by [method luaL_ref].       [br]
func luaL_unref(L: int, t: int, ref: int) -> Variant:
	return self.__luaL_unref.call_wasm_catch([L, t, ref])

# ["func_type", ["i32", "i32"], ["i32"]]
var __luaL_loadstring: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, –] [br]
## [code]int luaL_loadstring (lua_State *L, const char *s);[/code] [br]
##  [br]
##  Loads a string as a Lua chunk. This function uses [method lua_load] to load the chunk in the zero-terminated string [code]s[/code].    [br]
##  This function returns the same results as [method lua_load].    [br]
##  Also as [method lua_load], this function only loads the chunk; it does not run it.       [br]
func luaL_loadstring(L: int, s: int) -> Variant:
	return self.__luaL_loadstring.call_wasm_catch([L, s])

# ["func_type", ["i32", "i32", "i32"], ["i32"]]
var __luaL_getsubtable: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]int luaL_getsubtable (lua_State *L, int idx, const char *fname);[/code] [br]
##  [br]
##  Ensures that the value [code]t[fname][/code], where [code]t[/code] is the value at index [code]idx[/code], is a table, and pushes that table onto the stack. Returns true if it finds a previous table there and false if it creates a new table.       [br]
func luaL_getsubtable(L: int, idx: int, fname: int) -> Variant:
	return self.__luaL_getsubtable.call_wasm_catch([L, idx, fname])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __luaL_requiref: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, e] [br]
## [code]void luaL_requiref (lua_State *L, const char *modname,                     lua_CFunction openf, int glb);[/code] [br]
##  [br]
##  If [code]package.loaded[modname][/code] is not true, calls the function [code]openf[/code] with the string [code]modname[/code] as an argument and sets the call result to [code]package.loaded[modname][/code], as if that function has been called through [code]require[/code][/code].    [br]
##  If [code]glb[/code] is true, also stores the module into the global variable [code]modname[/code].    [br]
##  Leaves a copy of the module on the stack.       [br]
func luaL_requiref(L: int, modname: int, openf: int, glb: int) -> Variant:
	return self.__luaL_requiref.call_wasm_catch([L, modname, openf, glb])

# ["func_type", ["i32", "i32", "i32", "i32"], []]
var __luaL_addgsub: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-?, +?, m] [br]
## [code]const void luaL_addgsub (luaL_Buffer *B, const char *s,                          const char *p, const char *r);[/code] [br]
##  [br]
##  Adds a copy of the string [code]s[/code] to the buffer [code]B[/code] (see [method luaL_Buffer]), replacing any occurrence of the string [code]p[/code] with the string [code]r[/code].       [br]
func luaL_addgsub(b: int, s: int, p: int, r: int) -> Variant:
	return self.__luaL_addgsub.call_wasm_catch([b, s, p, r])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_gsub: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +1, m] [br]
## [code]const char *luaL_gsub (lua_State *L,                        const char *s,                        const char *p,                        const char *r);[/code] [br]
##  [br]
##  Creates a copy of string [code]s[/code], replacing any occurrence of the string [code]p[/code] with the string [code]r[/code]. Pushes the resulting string on the stack and returns it.       [br]
func luaL_gsub(L: int, s: int, p: int, r: int) -> Variant:
	return self.__luaL_gsub.call_wasm_catch([L, s, p, r])

# ["func_type", ["i32", "i32", "i32", "i32"], ["i32"]]
var __luaL_alloc: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [code]void *luaL_alloc (void *ud, void *ptr, size_t osize, size_t nsize);[/code] [br]
##  [br]
##  A standard allocator function for Lua (see [method lua_Alloc]), built on top of the C functions [code]realloc[/code] and [code]free[/code].       [br]
func luaL_alloc(ud: int, ptr: int, osize: int, nsize: int) -> Variant:
	return self.__luaL_alloc.call_wasm_catch([ud, ptr, osize, nsize])

# ["func_type", ["i32"], ["i32"]]
var __luaL_makeseed: WasmFunc
## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]
## For details, see [method WasmFunc.call_wasm_catch]
## [br][br]
## [-0, +0, –] [br]
## [code]unsigned int luaL_makeseed (lua_State *L);[/code] [br]
##  [br]
##  Returns a value with a weak attempt for randomness. The parameter [code]L[/code] can be [code]NULL[/code] if there is no Lua state available.       [br]
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
	