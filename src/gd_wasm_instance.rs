use godot::prelude::*;

use crate::{gd_wasm_module::WasmModule, gd_wasm_store::WasmStore, wasm_types::{gd_wasm_func::WasmFunc, gd_wasm_global::WasmGlobal, gd_wasm_memory::WasmMemory, gd_wasm_table::WasmTable}};

/// An instantiated Wasmtime Module.
/// 
/// **DO NOT USE `WasmInstance.new()` it will return null.**
/// 
/// Instead, use [method WasmLinker.instantiate]
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmInstance {
	instance: wasmtime::Instance,
    store: Gd<WasmStore>,
}

#[godot_api]
impl IRefCounted for WasmInstance {
    fn init(_base: Base<Self::Base>) -> Self {
        panic!("WasmInstance.new() is invalid!");
    }
}

#[godot_api]
impl WasmInstance {
    pub fn new(instance: wasmtime::Instance, store: Gd<WasmStore>) -> Self {
        return Self {
            instance,
            store,
        };
    }

    /// Get an exported [WasmGlobal] value by name.
    #[func]
    fn get_global(&mut self, name: GString) -> Option<Gd<WasmGlobal>> {
        let gd_store = self.store.clone();
        return match self.instance.get_global(&mut self.store.bind_mut().store, &name.to_string()) {
            Some(global) => Some(WasmGlobal::new_from(global, gd_store.into_dyn().upcast())),
            None => None,
        };
    }

    /// Get an exported [WasmFunc] value by name.
    #[func]
    fn get_func(&mut self, name: GString) -> Option<Gd<WasmFunc>> {
        let gd_store = self.store.clone();
        return match self.instance.get_func(&mut self.store.bind_mut().store, &name.to_string()) {
            Some(func) => Some(WasmFunc::new_from(func, gd_store.into_dyn().upcast())),
            None => None,
        };
    }

    /// Get an exported [WasmMemory] value by name.
    #[func]
    fn get_memory(&mut self, name: GString) -> Option<Gd<WasmMemory>> {
        let gd_store = self.store.clone();
        return match self.instance.get_memory(&mut self.store.bind_mut().store, &name.to_string()) {
            Some(memory) => Some(WasmMemory::new_from(memory, gd_store.into_dyn().upcast())),
            None => None,
        };
    }

    /// Get an exported [WasmTable] value by name.
    #[func]
    fn get_table(&mut self, name: GString) -> Option<Gd<WasmTable>> {
        let gd_store = self.store.clone();
        return match self.instance.get_table(&mut self.store.bind_mut().store, &name.to_string()) {
            Some(table) => Some(WasmTable::new_from(table, gd_store.into_dyn().upcast())),
            None => None,
        };
    }

    /// Gets the [WasmModule] which this instance was instantiated from.
    #[func]
    fn get_module(&mut self) -> Gd<WasmModule> {
        let store = &mut self.store.bind_mut().store;
        let module = self.instance.module(store);
        // `.clone()` is actually just for an Arc<>, so it's cheap.
        return WasmModule::from_module(module.clone());
    }
}
