use godot::prelude::*;


/// Global configuration options used to create an [`WasmEngine`] and customize its behavior.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmConfig {
	pub config: wasmtime::Config,
}

#[godot_api]
impl IRefCounted for WasmConfig {
    fn init(_base: Base<Self::Base>) -> Self {
        return Self {
            config: wasmtime::Config::new(),
        };
    }
}

#[godot_api]
impl WasmConfig {
}

macro_rules! make_config_setter {
    ($func_name:ident, $($arg_name:ident : $arg_type:ty),*) => {
        // This 'secondary' flag stops the __registration_storage duplication
        #[godot_api(secondary)]
        impl WasmConfig {
            #[func(gd_self)]
            fn $func_name(mut gd_self: Gd<Self>, $($arg_name: $arg_type),*) -> Gd<Self> {
                gd_self.bind_mut().config.$func_name($($arg_name),*);
                gd_self
            }
        }
    };
}

make_config_setter!(enable_compiler, enable: bool);
// TODO: target
// TODO: enable_incremental_compilation

make_config_setter!(debug_info, enable: bool);
make_config_setter!(guest_debug, enable: bool);
// make_config_setter!(wasm_backtrace_details, enable: WasmBacktraceDetails);
// make_config_setter!(wasm_backtrace_max_frames, limit: Option<NonZeroUsize>);
make_config_setter!(consume_fuel, enable: bool);
// make_config_setter!(operator_cost, cost: OperatorCost);
make_config_setter!(epoch_interruption, enable: bool);
// make_config_setter!(gc_zeal_alloc_counter, counter: Option<NonZeroU32>);
// make_config_setter!(max_wasm_stack, size: usize);
// make_config_setter!(async_stack_size, size: usize);
make_config_setter!(async_stack_zeroing, enable: bool);
// make_config_setter!(wasm_features, flag: WasmFeatures, enable: bool);
make_config_setter!(wasm_tail_call, enable: bool);
make_config_setter!(wasm_custom_page_sizes, enable: bool);
make_config_setter!(wasm_threads, enable: bool);
make_config_setter!(wasm_shared_everything_threads, enable: bool);
make_config_setter!(wasm_reference_types, enable: bool);
make_config_setter!(wasm_function_references, enable: bool);
make_config_setter!(wasm_wide_arithmetic, enable: bool);
make_config_setter!(wasm_gc, enable: bool);
make_config_setter!(wasm_simd, enable: bool);
make_config_setter!(wasm_relaxed_simd, enable: bool);
make_config_setter!(relaxed_simd_deterministic, enable: bool);
make_config_setter!(wasm_bulk_memory, enable: bool);
make_config_setter!(wasm_multi_value, enable: bool);
make_config_setter!(wasm_multi_memory, enable: bool);
make_config_setter!(wasm_memory64, enable: bool);
make_config_setter!(wasm_extended_const, enable: bool);
make_config_setter!(wasm_stack_switching, enable: bool);
make_config_setter!(wasm_component_model, enable: bool);
make_config_setter!(wasm_component_model_async, enable: bool);
make_config_setter!(wasm_component_model_more_async_builtins, enable: bool);
make_config_setter!(wasm_component_model_async_stackful, enable: bool);
make_config_setter!(wasm_component_model_threading, enable: bool);
make_config_setter!(wasm_component_model_error_context, enable: bool);
make_config_setter!(wasm_component_model_gc, enable: bool);
make_config_setter!(wasm_component_model_map, enable: bool);
make_config_setter!(wasm_component_model_fixed_length_lists, enable: bool);
make_config_setter!(wasm_exceptions, enable: bool);
// make_config_setter!(strategy, strategy: Strategy);
// make_config_setter!(collector, collector: Collector);
// make_config_setter!(profiler, profile: ProfilingStrategy);
make_config_setter!(cranelift_debug_verifier, enable: bool);
make_config_setter!(cranelift_wasmtime_debug_checks, enable: bool);
// make_config_setter!(cranelift_opt_level, level: OptLevel);
// make_config_setter!(cranelift_regalloc_algorithm, algo: RegallocAlgorithm);
make_config_setter!(cranelift_nan_canonicalization, enable: bool);
// make_config_setter!(cranelift_flag_enable, flag: &str);
// make_config_setter!(cranelift_flag_set, name: &str, value: &str);
// make_config_setter!(cache, cache: Option<Cache>);
// make_config_setter!(with_host_memory, mem_creator: Arc<dyn MemoryCreator>);
// make_config_setter!(with_host_stack, stack_creator: Arc<dyn StackCreator>);
// make_config_setter!(with_custom_code_memory, custom_code_memory: Option<Arc<dyn CustomCodeMemory>>);
// make_config_setter!(allocation_strategy, strategy: impl Into<InstanceAllocationStrategy>);
// make_config_setter!(memory_reservation, bytes: u64);
make_config_setter!(memory_may_move, enable: bool);
// make_config_setter!(memory_guard_size, bytes: u64);
// make_config_setter!(memory_reservation_for_growth, bytes: u64);
// make_config_setter!(gc_heap_reservation, bytes: u64);
// make_config_setter!(gc_heap_guard_size, bytes: u64);
// make_config_setter!(gc_heap_reservation_for_growth, bytes: u64);
make_config_setter!(gc_heap_may_move, enable: bool);
make_config_setter!(guard_before_linear_memory, enable: bool);
make_config_setter!(table_lazy_init, table_lazy_init: bool);
// make_config_setter!(module_version, strategy: ModuleVersionStrategy);
make_config_setter!(parallel_compilation, parallel: bool);
make_config_setter!(generate_address_map, generate: bool);
make_config_setter!(memory_init_cow, enable: bool);
make_config_setter!(force_memory_init_memfd, enable: bool);
make_config_setter!(coredump_on_trap, enable: bool);
make_config_setter!(wmemcheck, enable: bool);
// make_config_setter!(memory_guaranteed_dense_image_size, size_in_bytes: u64);
// make_config_setter!(compiler_inlining, inlining: Inlining);
// TODO: compiler_panicking_wasm_features
// TODO: features


// TODO: any_gc_heap_tunables_configured
make_config_setter!(debug_adapter_modules, debug: bool);
// make_config_setter!(signals_based_traps, path: &Path);
// make_config_setter!(emit_clif, path: &Path);
make_config_setter!(macos_use_mach_ports, mach_ports: bool);
// make_config_setter!(detect_host_feature, detect: fn(&str) -> Option<bool>);
make_config_setter!(signals_based_traps, enable: bool);
make_config_setter!(gc_support, enable: bool);
// make_config_setter!(x86_float_abi_ok, enable: bool);
make_config_setter!(shared_memory, enable: bool);
make_config_setter!(concurrency_support, enable: bool);
// make_config_setter!(validate_rr_determinism_conflicts);
// make_config_setter!(rr, cfg: RRConfig);
