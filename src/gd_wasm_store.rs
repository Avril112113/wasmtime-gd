use std::{cell::RefCell, rc::Rc};

use godot::prelude::*;
use wasmtime::AsContextMut;

use crate::{
	gd_wasm_engine::WasmEngine, gd_wasm_error::WasmError, store_data::StoreData, store_same_as::ContextStoreSameAs, utils::GdAsContext, utils_errors::{IntoMyGodotOption,IntoMyGodotResult, MyGodotResult}, wasm_types::gd_wasm_exn_ref::WasmExnRef
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
	pub store: Rc<RefCell<wasmtime::Store<StoreData>>>,

	#[var(get = get_fuel, set = _set_fuel)]
	fuel: PhantomVar<i64>,
	#[var(get = get_host_call_fuel_use, set = set_host_call_fuel_use)]
	host_call_fuel_use: PhantomVar<i64>,
}

#[godot_api]
impl IRefCounted for WasmStore {
	fn init(_base: Base<Self::Base>) -> Self {
		let store = Rc::new(RefCell::new(wasmtime::Store::new(&wasmtime::Engine::default(), StoreData::new())));
		// store.borrow_mut().data_mut().store = Some(store.clone());
		return Self {
			store,
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
		let store = Rc::new(RefCell::new(wasmtime::Store::new(&engine.bind().engine, StoreData::new())));
		// store.borrow_mut().data_mut().store = Some(store.clone());
		return Gd::from_object(Self {
			store,
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
		return self.as_context().get_fuel()
			.or_print_error("Failed to get fuel")
			.map(|v| v as i64)
			.unwrap_or(-1);
	}

	#[func]
	#[doc(hidden)]
	pub fn _set_fuel(&mut self, fuel: i64) {
		// Result is ignored
		self.as_context_mut().set_fuel(fuel as u64)
			.or_print_error("Failed to set fuel");
	}

	#[func]
	pub fn set_fuel(&mut self, fuel: i64) -> MyGodotResult<bool> {
		return self.as_context_mut().set_fuel(fuel as u64)
			.map(|()| true)
			.or_godot_error("Failed to set fuel", false);
	}

	#[func]
	pub fn get_host_call_fuel_use(&self) -> i64 {
		return self.as_context().data().call_fuel_use as i64;
	}

	#[func]
	pub fn set_host_call_fuel_use(&mut self, fuel: i64) {
		self.as_context_mut().data_mut().call_fuel_use = fuel as u64;
	}

	/// Take the pending WASM exception after a [WasmError] holding a thrown exception. See [method WasmError.is_throw_exception] [br]
    /// Returns `null` if there is no pending WASM exception. [br]
	#[func(gd_self)]
	fn take_pending_exception(gd_self: Gd<Self>) -> Option<Gd<WasmExnRef>> {
		if let Some(exn_ref) = gd_self.clone().bind_mut().as_context_mut().take_pending_exception() {
			return Some(WasmExnRef::new_from(exn_ref, gd_self.into_dyn().upcast()));
		}
		return None;
	}

    /// Set an exception as the currently pending exception, and return an error that propagates the throw. [br]
    ///
    /// This method takes an exception object and stores it in the `Store` as the currently pending exception. [br]
    /// This is a special rooted slot that holds the exception as long as it is propagating. [br]
    /// This method then returns a [WasmError] holding a thrown exception, which is a special case that indicates a pending exception exists. [br]
    /// When this [WasmError] propagates as an error returned from a Wasm-to-host call, the pending exception is thrown within the Wasm context, and either caught or propagated further to the host-to-Wasm call boundary. [br]
    /// If an exception is thrown out of Wasm (or across Wasm from a hostcall) back to the host-to-Wasm call boundary, *that* invocation returns a `ThrownException`, and the pending exception slot is again set. [br]
    /// In other words, a [WasmError] holding a thrown exception should propagate upward exactly and only when a pending exception is set. [br]
    /// [br]
    /// If there is already a pending exception in the store then the previous one will be overwritten. [br]
	/// [br]
	/// NOTE: Taking a pending exception and re-throwing it using the original [WasmError] instead of the one returned by this method, will retain the backtrack.
	#[func]
	fn throw(&mut self, mut exn_ref: Gd<WasmExnRef>) -> Gd<WasmError> {
        return WasmError::new_from_error(self.as_context_mut().throw::<()>(exn_ref.bind_mut().exn_ref).unwrap_err());
	}
}

#[godot_dyn]
impl GdAsContext for WasmStore {
	fn get_context(&self) -> Rc<RefCell<dyn AsContextMut<Data = StoreData>>> {
		return self.store.clone();
	}
}
