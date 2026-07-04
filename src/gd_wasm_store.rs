use godot::prelude::*;
use wasmtime::{AsContext, AsContextMut};

use crate::{gd_wasm_engine::WasmEngine, store_same_as::ContextStoreSameAs, utils::GdAsContext, utils_errors::{IntoMyGodotOption, IntoMyGodotResult, MyGodotResult}};

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
	/// Creates a new [WasmStore], which is a collection of WebAssembly instances and host-defined state.
	#[func]
	fn new_with(engine: Gd<WasmEngine>) -> Gd<Self> {
		return Gd::from_object(Self {
			store: wasmtime::Store::new(&engine.bind().engine, ()),
		});
	}

	/// Check if 2 [WasmStore]s are actually the same store.
	/// Note that, many separate [WasmStore] objects can refer to the same store!
	#[func]
	pub fn same_as(&self, other: DynGd<RefCounted, dyn GdAsContext>) -> bool {
		return self.as_context().same_store_as(&other.dyn_bind().as_context());
	}

	#[func]
	pub fn get_fuel(&self) -> i64 {
		return self.store.get_fuel()
			.or_print_error("Failed to get fuel")
			.map(|v| v as i64)
			.unwrap_or(-1);
	}

	#[func]
	pub fn set_fuel(&mut self, fuel: i64) -> MyGodotResult<bool> {
		return self.store.set_fuel(fuel as u64)
			.map(|()| true)
			.or_godot_error("Failed to get fuel", false);
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
