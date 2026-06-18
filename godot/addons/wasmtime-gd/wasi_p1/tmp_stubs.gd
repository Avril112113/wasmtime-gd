extends RefCounted
class_name Wasip1TmpStubs


const MODULE_NAME = "wasi_snapshot_preview1"


func define_feature(linker: WasmLinker, store: WasmStore) -> bool:
	var ok := true
	
	ok = linker.define(store, MODULE_NAME, "fd_close", WasmFunc.from_callable(store, ["i32"], ["i32"], func(caller, arg1): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_fdstat_get", WasmFunc.from_callable(store, ["i32", "i32"], ["i32"], func(caller, arg1, arg2): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_fdstat_set_flags", WasmFunc.from_callable(store, ["i32", "i32"], ["i32"], func(caller, arg1, arg2): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_prestat_get", WasmFunc.from_callable(store, ["i32", "i32"], ["i32"], func(caller, arg1, arg2): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_prestat_dir_name", WasmFunc.from_callable(store, ["i32", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_read", WasmFunc.from_callable(store, ["i32", "i32", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3, arg4): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_renumber", WasmFunc.from_callable(store, ["i32", "i32"], ["i32"], func(caller, arg1, arg2): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_seek", WasmFunc.from_callable(store, ["i32", "i64", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3, arg4): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "fd_write", WasmFunc.from_callable(store, ["i32", "i32", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3, arg4): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "path_open", WasmFunc.from_callable(store, ["i32", "i32", "i32", "i32", "i32", "i64", "i64", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "path_remove_directory", WasmFunc.from_callable(store, ["i32", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "path_rename", WasmFunc.from_callable(store, ["i32", "i32", "i32", "i32", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3, arg4, arg5, arg6): return WasmError.new_from("Not Implemented"))) and ok
	ok = linker.define(store, MODULE_NAME, "path_unlink_file", WasmFunc.from_callable(store, ["i32", "i32", "i32"], ["i32"], func(caller, arg1, arg2, arg3): return WasmError.new_from("Not Implemented"))) and ok
	
	return ok
