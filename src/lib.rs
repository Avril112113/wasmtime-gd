#![allow(dead_code)]

mod gd_script_stuff;

mod utils_errors;
mod utils;

mod to_from_variant;
mod wasm_types;

mod gd_wasm_error;
mod gd_wasm_config;
mod gd_wasm_module;
mod gd_wasm_engine;
mod gd_wasm_linker;
mod gd_wasm_store;
mod gd_wasm_caller;
mod gd_wasm_instance;
mod store_same_as;

use godot::prelude::*;


#[allow(dead_code)]
struct WasmtimeGD;


#[gdextension]
unsafe impl ExtensionLibrary for WasmtimeGD {}
