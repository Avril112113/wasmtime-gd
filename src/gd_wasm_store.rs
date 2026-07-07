use godot::prelude::*;
use wasmtime::{AsContext, AsContextMut};

use crate::{
	gd_wasm_engine::WasmEngine, store_data::StoreData, store_same_as::ContextStoreSameAs,
	utils::GdAsContext, utils_errors::{IntoMyGodotOption,IntoMyGodotResult, MyGodotResult}
};

/// A Wasmtime Linker, to link wasm modules/instances together and provide imports from the host.
/// 
/// * `WasmStore.new()` creates a wasmtime store with the default engine and config.
/// * `WasmStore.new_with(engine)` creates a wasmtime store with the provided engine.
/// 
/// **WARNING:** Mixing [WasmStore]s may cause crashes! Additionally, check Wasmtime docs on using multiple stores.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmStore {
	pub store: wasmtime::Store<StoreData>,

	#[var(get = get_fuel, set = _set_fuel)]
	fuel: PhantomVar<i64>,
	#[var(get = get_host_call_fuel_use, set = set_host_call_fuel_use)]
	host_call_fuel_use: PhantomVar<i64>,
}

#[godot_api]
impl IRefCounted for WasmStore {
	fn init(_base: Base<Self::Base>) -> Self {
		return Self {
			store: wasmtime::Store::new(&wasmtime::Engine::default(), StoreData::new()),
			fuel: Default::default(),
			host_call_fuel_use: Default::default(),
		};
	}
}

#[godot_api]
impl WasmStore {
	/// Creates a new [WasmStore], which is a collection of WebAssembly instances and host-defined state.
	#[func]
	fn new_with(engine: Gd<WasmEngine>) -> Gd<Self> {
		return Gd::from_object(Self {
			store: wasmtime::Store::new(&engine.bind().engine, StoreData::new()),
			fuel: Default::default(),
			host_call_fuel_use: Default::default(),
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
	#[doc(hidden)]
	pub fn _set_fuel(&mut self, fuel: i64) {
		// Result is ignored
		self.store.set_fuel(fuel as u64)
			.or_print_error("Failed to set fuel");
	}

	#[func]
	pub fn set_fuel(&mut self, fuel: i64) -> MyGodotResult<bool> {
		return self.store.set_fuel(fuel as u64)
			.map(|()| true)
			.or_godot_error("Failed to set fuel", false);
	}

	#[func]
	pub fn get_host_call_fuel_use(&self) -> i64 {
		return self.store.data().call_fuel_use as i64;
	}

	#[func]
	pub fn set_host_call_fuel_use(&mut self, fuel: i64) {
		self.store.data_mut().call_fuel_use = fuel as u64;
	}
}

#[godot_dyn]
impl GdAsContext for WasmStore {
	fn as_context(&self) -> wasmtime::StoreContext<'_, StoreData> {
		return self.store.as_context();
	}

	fn as_context_mut(&mut self) -> wasmtime::StoreContextMut<'_, StoreData> {
		return self.store.as_context_mut();
	}
}
