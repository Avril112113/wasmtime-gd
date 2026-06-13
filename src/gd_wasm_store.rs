use godot::prelude::*;
use wasmtime::AsContext;

use crate::gd_wasm_engine::WasmEngine;

/// A Wasmtime Linker, to link wasm modules/instances together and provide imports from the host.
/// 
/// **DO NOT USE `WasmStore.new()` it will return null.**
/// 
/// **WARNING:** Mixing [WasmStore] may cause crashes! Additionally, check Wasmtime docs on using multiple stores.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmStore {
	pub store: wasmtime::Store<()>,
    pub engine: Gd<WasmEngine>,
}

#[godot_api]
impl IRefCounted for WasmStore {
    fn init(_base: Base<Self::Base>) -> Self {
        panic!("WasmStore.new() is invalid!");
    }
}

#[godot_api]
impl WasmStore {
    #[func]
    fn new_with(engine: Gd<WasmEngine>) -> Gd<Self> {
        let gd_engine = engine.clone();
		return Gd::from_object(Self {
            store: wasmtime::Store::new(&engine.bind().engine, ()),
            engine: gd_engine,
        });
    }

    pub fn same_as_(&self, other: &WasmStore) -> bool {
        let ptr_a = self.store.as_context().data() as *const ();
        let ptr_b = other.store.as_context().data() as *const ();
        return std::ptr::eq(ptr_a, ptr_b);
    }

    #[func]
    pub fn same_as(&self, other: Gd<WasmStore>) -> bool {
        return self.same_as_(&other.bind());
    }
}
