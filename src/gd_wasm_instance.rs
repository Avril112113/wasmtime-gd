use godot::prelude::*;

use crate::{active_context::WasmContext, gd_wasm_module::WasmModule, gd_wasm_store::WasmStore, utils::GdAsContext, wasm_types::{gd_wasm_func::WasmFunc, gd_wasm_global::WasmGlobal, gd_wasm_memory::WasmMemory, gd_wasm_table::WasmTable, gd_wasm_tag::WasmTag}};

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

    /// Gets the [WasmModule] which this instance was instantiated from.
    #[func]
    fn get_module(&mut self) -> Gd<WasmModule> {
        // `.clone()` is actually just for an Arc<>, so it's cheap.
        return WasmModule::from_module(self.instance.module(&mut self.store.bind_mut().as_context_mut()).clone());
    }

    /// Get an exported [WasmGlobal] value by name.
    #[func]
    fn get_global(&mut self, name: GString) -> Option<Gd<WasmGlobal>> {
        let gd_store = self.store.clone();
        let context = WasmContext::new(gd_store.into_dyn().upcast());
        return self.instance.get_global(&mut self.store.bind_mut().as_context_mut(), &name.to_string())
            .map(|global| WasmGlobal::new_from(global, context));
    }

    /// Get an exported [WasmFunc] value by name.
    #[func]
    fn get_func(&mut self, name: GString) -> Option<Gd<WasmFunc>> {
        let gd_store = self.store.clone();
        let context = WasmContext::new(gd_store.into_dyn().upcast());
        return self.instance.get_func(&mut self.store.bind_mut().as_context_mut(), &name.to_string())
            .map(|func| WasmFunc::new_from(func, context));
    }

    /// Get an exported [WasmMemory] value by name.
    #[func]
    fn get_memory(&mut self, name: GString) -> Option<Gd<WasmMemory>> {
        let gd_store = self.store.clone();
        let context = WasmContext::new(gd_store.into_dyn().upcast());
        return self.instance.get_memory(&mut self.store.bind_mut().as_context_mut(), &name.to_string())
            .map(|memory| WasmMemory::new_from(memory, context));
    }

    /// Get an exported [WasmTable] value by name.
    #[func]
    fn get_table(&mut self, name: GString) -> Option<Gd<WasmTable>> {
        let gd_store = self.store.clone();
        let context = WasmContext::new(gd_store.into_dyn().upcast());
        return self.instance.get_table(&mut self.store.bind_mut().as_context_mut(), &name.to_string())
            .map(|table| WasmTable::new_from(table, context));
    }

    /// Get an exported [WasmTag] value by name.
    #[func]
    fn get_tag(&mut self, name: GString) -> Option<Gd<WasmTag>> {
        let gd_store = self.store.clone();
        let context = WasmContext::new(gd_store.into_dyn().upcast());
        return self.instance.get_tag(&mut self.store.bind_mut().as_context_mut(), &name.to_string())
            .map(|tag| WasmTag::new_from(tag, context));
    }
}
