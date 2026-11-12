use std::{cell::RefCell, rc::Rc};

use godot::{classes::class_macros::sys::is_editor, prelude::*};
use wasmtime::{AsContextMut, Caller};

use crate::{
    active_context::WasmContext, gd_script_stuff::GDScriptStuff, gd_wasm_error::WasmError, store_data::StoreData, to_from_variant::to_from_godot::ToFromVariantContext, utils::GdAsContext, utils_errors::{IntoMyGodotOption, IntoMyGodotResult, MyGodotResult}, wasm_types::{gd_wasm_exn_ref::WasmExnRef, gd_wasm_memory::WasmMemory}
};


/// A Wasmtime Extern::Global
/// 
/// Note: A simple `==` between [WasmCaller] is not enough, use [method same_as]
/// 
/// Note: "incompatible import type" can be due to differing mutability!
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmCaller {
	caller: Option<Rc<RefCell<wasmtime::Caller<'static, StoreData>>>>,

	#[var(get = get_fuel, set = _set_fuel)]
	fuel: PhantomVar<i64>,
}

#[godot_api]
impl IRefCounted for WasmCaller {
    fn init(_base: Base<Self::Base>) -> Self {
        if !is_editor() {
            GDScriptStuff::print_error("WasmCaller.new() is invalid!", None, None);
        }
        return Self { caller: None, fuel: Default::default() }
    }
}

#[godot_api]
impl WasmCaller {
    pub fn new_from(caller: Caller<'static, StoreData>) -> Gd<Self> {
        return Gd::from_object(Self {
            caller: Some(Rc::new(RefCell::new(caller))),
            fuel: Default::default(),
        })
    }

    pub fn invalidate(&mut self) {
        self.caller = None;
    }

    /// Get's an export from the caller's instance. [br]
    /// If an export with the [param name] doesn't exit, [code]null[/code] is returned.
    #[func(gd_self)]
    fn get_export(gd_self: Gd<Self>, name: GString) -> Variant {
        // TODO: Don't unwrap.
        let context = WasmContext::new(gd_self.clone().into_dyn().upcast());
        match gd_self.clone().bind_mut().caller.clone().unwrap().borrow_mut().get_export(&name.to_string()) {
            Some(exter) => exter.to_variant(&context),
            None => Variant::nil(),
        }
    }

    /// Get's an exported memory. If the [param name] doesn't exist or isn't a memory, [code]null[/code] is returned.
    #[func(gd_self)]
    fn get_memory(gd_self: Gd<Self>, #[opt(default="memory")] name: GString) -> Option<Gd<WasmMemory>> {
        // TODO: Don't unwrap.
        let context = WasmContext::new(gd_self.clone().into_dyn().upcast());
        match gd_self.clone().bind_mut().caller.clone().unwrap().borrow_mut().get_export(&name.to_string()) {
            Some(wasmtime::Extern::Memory(memory)) => Some(WasmMemory::new_from(memory, context)),
            _ => None,
        }
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

	/// Take the pending WASM exception after a [WasmError] holding a thrown exception. See [method WasmError.is_throw_exception] [br]
    /// Returns `null` if there is no pending WASM exception.
	#[func(gd_self)]
	fn take_pending_exception(gd_self: Gd<Self>) -> Option<Gd<WasmExnRef>> {
		if let Some(exn_ref) = gd_self.clone().bind_mut().as_context_mut().take_pending_exception() {
			return Some(WasmExnRef::new_from(exn_ref, WasmContext::new(gd_self.into_dyn().upcast())));
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
    /// If there is already a pending exception in the store then the previous one will be overwritten.
	#[func]
	fn throw(&mut self, mut exn_ref: Gd<WasmExnRef>) -> Gd<WasmError> {
        return WasmError::new_from_error(self.as_context_mut().throw::<()>(exn_ref.bind_mut().exn_ref).unwrap_err());
	}
}

#[godot_dyn]
impl GdAsContext for WasmCaller {
	fn get_context(&self) -> Rc<RefCell<dyn AsContextMut<Data = StoreData>>> {
        // TODO: Don't unwrap.
		return self.caller.clone().unwrap();
	}
}
