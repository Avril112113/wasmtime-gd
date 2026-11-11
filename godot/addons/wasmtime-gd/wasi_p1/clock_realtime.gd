extends RefCounted
class_name Wasip1ClockRealtime


const MODULE_NAME = "wasi_snapshot_preview1"


var epoch_ticks := Time.get_ticks_usec()

var now_nsec: int:
	get:
		return unix_timestamp_to_clock_timestamp(Time.get_unix_time_from_system())

var now_monotonic_process_nsec: int:
	get:
		return (Time.get_ticks_usec() - epoch_ticks) * 1_000


## Make sure to keep a reference to this RefCounted object!
## See https://github.com/godotengine/godot/issues/74990
## TODO: Check if we still need to worry about this, since we changed how [WasmUtils._define_func_name] works.
func _init() -> void:
	pass

func unix_timestamp_to_clock_timestamp(unix_timestamp: float) -> int:
	return floor(unix_timestamp * 1_000_000_000)


func define_feature(linker: WasmLinker, store: WasmStore) -> bool:
	return WasmUtils._define_many_func_name(self, linker, store, [
		"clock_res_get",
		"clock_time_get",
	])

## https://wasix.org/docs/api-reference/wasi/clock_res_get
var _wasm_clock_res_get = [
	[WasmTypes.I32, WasmTypes.I32],
	[WasmTypes.I32],
	func _wasm_clock_res_get(caller: WasmCaller, clock_id: int, precision: int) -> int:
		var memory: WasmMemory = caller.get_export("memory")
		if clock_id == Wasip1Consts.Clock.REALTIME:
			# get_unix_time_from_system is micro-sec accuracy
			memory.write_u64(precision, 1_000)
		elif clock_id == Wasip1Consts.Clock.MONOTONIC or clock_id == Wasip1Consts.Clock.PROCESS_CPUTIME_ID or clock_id == Wasip1Consts.Clock.THREAD_CPUTIME_ID:
			# get_ticks_usec is micro-sec accuracy
			memory.write_u64(precision, 1_000)
		else:
			return Wasip1Consts.Errno.EINVAL
		return Wasip1Consts.Errno.ESUCCESS
]

## https://wasix.org/docs/api-reference/wasi/clock_time_get
var _wasm_clock_time_get = [
	[WasmTypes.I32, WasmTypes.I64, WasmTypes.I32],
	[WasmTypes.I32],
	func _wasm_clock_time_get(caller: WasmCaller, clock_id: int, precision: int, time_nsec: int) -> int:
		var memory: WasmMemory = caller.get_export("memory")
		if clock_id == Wasip1Consts.Clock.REALTIME:
			memory.write_u64(time_nsec, now_nsec)
		elif clock_id == Wasip1Consts.Clock.MONOTONIC or clock_id == Wasip1Consts.Clock.PROCESS_CPUTIME_ID or clock_id == Wasip1Consts.Clock.THREAD_CPUTIME_ID:
			memory.write_u64(time_nsec, now_monotonic_process_nsec)
		else:
			return Wasip1Consts.Errno.EINVAL
		return Wasip1Consts.Errno.ESUCCESS
]
