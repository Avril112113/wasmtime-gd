use godot::prelude::*;

use crate::{gd_wasm_store::WasmStore, wasm_types::{gd_wasm_func::WasmFunc, gd_wasm_global::WasmGlobal}};

/// An instantiated Wasmtime Module.
/// 
/// **DO NOT USE `WasmInstance.new()` it will return null.**
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmInstance {
	instance: wasmtime::Instance,
}

#[godot_api]
impl IRefCounted for WasmInstance {
    fn init(_base: Base<Self::Base>) -> Self {
        panic!("WasmInstance.new() is invalid!");
    }
}

#[godot_api]
impl WasmInstance {
    pub fn new(instance: wasmtime::Instance) -> Self {
        return Self {
            instance,
        };
    }

    #[func]
    fn get_global(&mut self, mut store: Gd<WasmStore>, name: GString) -> Option<Gd<WasmGlobal>> {
        let gd_store = store.clone();
        return match self.instance.get_global(&mut store.bind_mut().store, &name.to_string()) {
            Some(global) => Some(WasmGlobal::new_from(global, gd_store)),
            None => None,
        };
    }

    #[func]
    fn get_func(&mut self, mut store: Gd<WasmStore>, name: GString) -> Option<Gd<WasmFunc>> {
        let gd_store = store.clone();
        return match self.instance.get_func(&mut store.bind_mut().store, &name.to_string()) {
            Some(func) => Some(WasmFunc::new_from(func, gd_store)),
            None => None,
        };
    }
}
