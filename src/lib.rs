#![allow(dead_code)]
#![feature(fn_traits)]
#![feature(int_roundings)]
#![feature(current_thread_id)]
#![feature(thread_id_value)]

mod gd_script_stuff;

mod utils_errors;
mod utils;

mod to_from_variant;
mod wasm_types;

mod store_data;

mod gd_wasm_error;
mod gd_wasm_dwarf;
mod gd_wasm_config;
mod gd_wasm_module;
mod gd_wasm_engine;
mod gd_wasm_linker;
mod gd_wasm_store;
mod gd_wasm_caller;
mod gd_wasm_instance;
mod store_same_as;
mod thread_safe_variant;

use godot::prelude::*;


#[allow(dead_code)]
struct WasmtimeGD;


#[gdextension]
unsafe impl ExtensionLibrary for WasmtimeGD {
	fn on_stage_init(stage: InitStage) {
		// SAFETY: We assume no other threads are trying to modify the env vars during gdextension init.

		if stage == InitStage::Core {
			unsafe { std::env::set_var("RUST_BACKTRACE", "1"); }
		}

		if stage == InitStage::Scene {
			#[cfg(debug_assertions)]
			godot_print!("Using debug build of wasmtime-gd, performance will be impacted.");
		}
	}
}
