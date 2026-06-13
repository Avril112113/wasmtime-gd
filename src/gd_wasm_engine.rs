use godot::prelude::*;

use crate::{gd_wasm_config::WasmConfig, utils_errors::*};

/// A Wasmtime Engine which is a global context for compilation and management of wasm modules.
/// 
/// * `WasmEngine.new()` creates a wasmtime engine with the default config.
/// * `WasmEngine.new_with(config)` creates a wasmtime engine with the specified config.
/// 
/// **WARNING:** Mixing [WasmEngine] may cause crashes!
/// For example a [WasmLinker] commonly takes a [WasmStore], if the [WasmLinker] and [WasmStore] were created with different [WasmEngine], this will crash the editor/game.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmEngine {
	pub engine: wasmtime::Engine,
}

#[godot_api]
impl IRefCounted for WasmEngine {
    fn init(_base: Base<Self::Base>) -> Self {
        return Self {
            engine: wasmtime::Engine::default(),
        }
    }
}

#[godot_api]
impl WasmEngine {
    /// Creates a new wasmtime engine, with the specified config.
    /// 
    /// May return `null` in case of error, which will be logged.
    #[func]
    fn new_with(config: Gd<WasmConfig>) -> Option<Gd<Self>> {
        let engine = wasmtime::Engine::new(&config.bind().config)
            .or_print_error("Failed to create Engine:")?;
		return Some(Gd::from_object(Self {
            engine,
        }));
    }
}
