use godot::prelude::*;
use wasmtime::{AsContext, AsContextMut};

use crate::{gd_wasm_engine::WasmEngine, store_same_as::ContextStoreSameAs, utils::GdAsContext};

/// A Wasmtime Linker, to link wasm modules/instances together and provide imports from the host.
/// 
/// **DO NOT USE `WasmStore.new()` it will return null.**
/// 
/// **WARNING:** Mixing [WasmStore] may cause crashes! Additionally, check Wasmtime docs on using multiple stores.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmStore {
	pub store: wasmtime::Store<()>,
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
		return Gd::from_object(Self {
			store: wasmtime::Store::new(&engine.bind().engine, ()),
		});
	}

	#[func]
	pub fn same_as(&self, other: DynGd<RefCounted, dyn GdAsContext>) -> bool {
		return self.as_context().same_store_as(&other.dyn_bind().as_context());
	}
}

#[godot_dyn]
impl GdAsContext for WasmStore {
	fn as_context(&self) -> wasmtime::StoreContext<'_, ()> {
		return self.store.as_context();
	}

	fn as_context_mut(&mut self) -> wasmtime::StoreContextMut<'_, ()> {
		return self.store.as_context_mut();
	}
}
