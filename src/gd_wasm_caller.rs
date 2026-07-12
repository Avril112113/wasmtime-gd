use godot::{classes::class_macros::sys::is_editor, prelude::*};
use wasmtime::{AsContext, AsContextMut};

use crate::{
    gd_script_stuff::GDScriptStuff, store_data::StoreData, to_from_variant::to_from_godot::ToFromVariantContext, utils::GdAsContext, utils_errors::{IntoMyGodotOption, IntoMyGodotResult, MyGodotResult}, wasm_types::gd_wasm_memory::WasmMemory
};


/// A Wasmtime Extern::Global
/// 
/// Note: A simple `==` between [WasmCaller] is not enough, use [method same_as]
/// 
/// Note: "incompatible import type" can be due to differing mutability!
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmCaller {
	caller: Option<wasmtime::Caller<'static, StoreData>>,

	#[var(get = get_fuel, set = _set_fuel)]
	fuel: PhantomVar<i64>,
}

#[godot_api]
impl IRefCounted for WasmCaller {
    fn init(_base: Base<Self::Base>) -> Self {
        if !is_editor() {
            GDScriptStuff::print_error("WasmCaller.new() is invalid!", None);
        }
        return Self { caller: None, fuel: Default::default() }
    }
}

#[godot_api]
impl WasmCaller {
    pub fn new_from(caller: wasmtime::Caller<'static, StoreData>) -> Gd<Self> {
        return Gd::from_object(Self {
            caller: Some(caller),
            fuel: Default::default(),
        })
    }

    pub fn invalidate(&mut self) {
        self.caller = None;
    }

    /// Get's an export from the caller's instance. [br]
    /// If an export with the [param name] doesn't exit, [null] is returned.
    #[func(gd_self)]
    fn get_export(gd_self: Gd<Self>, name: GString) -> Variant {
        match gd_self.clone().bind_mut().caller.as_mut().unwrap().get_export(&name.to_string()) {
            Some(exter) => exter.to_variant(gd_self.into_dyn().upcast()),
            None => Variant::nil(),
        }
    }

    /// Get's an exported memory. If the [param name] doesn't exist or isn't a memory, [code]null[/code] is returned.
    #[func(gd_self)]
    fn get_memory(gd_self: Gd<Self>, #[opt(default="memory")] name: GString) -> Option<Gd<WasmMemory>> {
        match gd_self.clone().bind_mut().caller.as_mut().unwrap().get_export(&name.to_string()) {
            Some(exter) => {
                match exter {
                    wasmtime::Extern::Memory(memory) => Some(WasmMemory::new_from(memory, gd_self.into_dyn().upcast())),
                    _ => None,
                }
            },
            None => None,
        }
    }

	#[func]
	pub fn get_fuel(&self) -> i64 {
		return self.caller.as_ref().unwrap().get_fuel()
			.or_print_error("Failed to get fuel")
			.map(|v| v as i64)
			.unwrap_or(-1);
	}

	#[func]
	#[doc(hidden)]
	pub fn _set_fuel(&mut self, fuel: i64) {
		// Result is ignored
		self.caller.as_mut().unwrap().set_fuel(fuel as u64)
			.or_print_error("Failed to set fuel");
	}

	#[func]
	pub fn set_fuel(&mut self, fuel: i64) -> MyGodotResult<bool> {
		return self.caller.as_mut().unwrap().set_fuel(fuel as u64)
			.map(|()| true)
			.or_godot_error("Failed to set fuel", false);
	}
}

#[godot_dyn]
impl GdAsContext for WasmCaller {
	fn as_context(&self) -> wasmtime::StoreContext<'_, StoreData> {
		return self.caller.as_ref().unwrap().as_context();
	}

	fn as_context_mut(&mut self) -> wasmtime::StoreContextMut<'_, StoreData> {
		return self.caller.as_mut().unwrap().as_context_mut();
	}
}
