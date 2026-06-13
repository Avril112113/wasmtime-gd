#![allow(dead_code)]

mod utils_errors;
mod utils;

mod gd_wasm_types;
mod gd_wasm_config;
mod gd_wasm_module;
mod gd_wasm_engine;
mod gd_wasm_linker;
mod gd_wasm_store;
mod gd_wasm_instance;

mod wasm_types;

use godot::prelude::*;


#[allow(dead_code)]
struct WasmtimeGD;


#[gdextension]
unsafe impl ExtensionLibrary for WasmtimeGD {}
