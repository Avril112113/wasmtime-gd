@abstract
extends Object
class_name WasmUtils


## [param feature] should have a const [code]MODULE_NAME[/code]
## Looks for [code]_wasm_NAME[/code] with the following format; [[ARG_TYPE, ...], [RESULT_TYPE, ...], Callable]
static func _define_func_name(feature, linker: WasmLinker, store: WasmStore, name: String) -> bool:
	var module_name = feature.MODULE_NAME
	var info = feature["_wasm_" + name]
	var arg_types = info[0]
	var result_types = info[1]
	var callable = info[2]
	#var callable = func(...args):
		#var result: Variant = info[2].callv(args)
		#args.pop_front()
		#print(name, args, " = ", result)
		#return result
	return linker.define(store, module_name, name, WasmFunc.from_callable(store, arg_types, result_types, callable))

## [param feature] should have a const [code]MODULE_NAME[/code]
## Attempts to define all and returns [code]false[/code] if any failed.
static func _define_many_func_name(feature, linker: WasmLinker, store: WasmStore, names: Array[String]) -> bool:
	var ok := true
	for name in names:
		ok = _define_func_name(feature, linker, store, name) and ok 
	return ok

#typedef struct __wasi_iovec_s {
#  void* buf;
#  size_t buf_len;
#} __wasi_iovec_t;

static func read_iovs_total_buf_len(memory: WasmMemory, iovs: int, iovs_len: int) -> int:
	var total_len := 0
	var iovs_pos := iovs
	for i in range(0, iovs_len):
		var buf_ptr := memory.read_u32(iovs_pos)
		iovs_pos += 4
		var buf_len := memory.read_u32(iovs_pos)
		iovs_pos += 4
		
		total_len += buf_len
	
	return total_len

static func write_iovs(memory: WasmMemory, iovs: int, iovs_len: int, bytes: PackedByteArray) -> int:
	var bytes_pos := 0
	var iovs_pos := iovs
	for i in range(0, iovs_len):
		var buf_ptr := memory.read_u32(iovs_pos)
		iovs_pos += 4
		var buf_len := memory.read_u32(iovs_pos)
		iovs_pos += 4
		
		var write_count := min(len(bytes) - bytes_pos, buf_len)
		bytes_pos += write_count
		if memory.write(buf_ptr, bytes.slice(bytes_pos-write_count, bytes_pos)) == 0:
			break
		if bytes_pos >= len(bytes):
			break
	
	return bytes_pos

static func read_iovs(memory: WasmMemory, iovs: int, iovs_len: int) -> PackedByteArray:
	var bytes := PackedByteArray()
	var iovs_pos := iovs
	for i in range(0, iovs_len):
		var buf_ptr := memory.read_u32(iovs_pos)
		iovs_pos += 4
		var buf_len := memory.read_u32(iovs_pos)
		iovs_pos += 4
		
		var read_bytes := memory.read(buf_ptr, buf_len)
		if len(read_bytes) > 0:
			bytes.append_array(read_bytes)
	return bytes
