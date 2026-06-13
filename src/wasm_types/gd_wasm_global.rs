use godot::prelude::*;
use wasmtime::{GlobalType, Mutability, Val::*, ValType};

use crate::{gd_wasm_store::WasmStore, utils_errors::*, wasm_types::ValFromVariantByValType};
use super::WasmAsExtern;


// TODO: Split out GlobalType and Val


/// A Wasmtime Extern::Global
/// 
/// Note: A simple `==` between [WasmGlobal] is not enough, use [method same_as]
/// 
/// Note: "incompatible import type" can be due to differing mutability!
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmGlobal {
	pub global: wasmtime::Global,
    store: Gd<WasmStore>,
}

#[godot_dyn]
impl WasmAsExtern for WasmGlobal {
    fn as_extern(&self) -> wasmtime::Extern {
        return wasmtime::Extern::Global(self.global);
    }
}

#[godot_api]
impl IRefCounted for WasmGlobal {
    fn init(_base: Base<Self::Base>) -> Self {
        panic!("WasmGlobal.new() is invalid!");
    }
}

#[godot_api]
impl WasmGlobal {
    pub fn new_from(global: wasmtime::Global, store: Gd<WasmStore>) -> Gd<Self> {
        return Gd::from_object(WasmGlobal {
            global,
            store,
        })
    }

    // TODO: Move godot new methods to the [WasmStore] impl.
    //       store.create_global(WasmGlobal.CONST, WasmGlobal.I32, 404)

    fn new_global(mut store: Gd<WasmStore>, val_type: ValType, mutable: bool, default: wasmtime::Val) -> Option<Gd<Self>> {
        let global_type = GlobalType::new(val_type, if mutable {Mutability::Var} else {Mutability::Const});
        let global = wasmtime::Global::new(&mut store.bind_mut().store, global_type, default)
            .or_print_error("Failed to create Global:")?;
		return Some(Gd::from_object(Self {
            global,
            store,
        }));
    }

    #[func]
    fn new_i32(store: Gd<WasmStore>, default: i32, mutable: bool) -> Option<Gd<Self>> {
        return Self::new_global(store, ValType::I32, mutable, I32(default));
    }

    #[func]
    fn new_i64(store: Gd<WasmStore>, default: i64, mutable: bool) -> Option<Gd<Self>> {
        return Self::new_global(store, ValType::I64, mutable, I64(default));
    }

    #[func]
    fn new_f32(store: Gd<WasmStore>, default: f32, mutable: bool) -> Option<Gd<Self>> {
        return Self::new_global(store, ValType::F32, mutable, F32(default.to_bits()));
    }

    #[func]
    fn new_f64(store: Gd<WasmStore>, default: f64, mutable: bool) -> Option<Gd<Self>> {
        return Self::new_global(store, ValType::F64, mutable, F64(default.to_bits()));
    }

    // TODO
    // #[func]
    // fn new_v128(store: Gd<WasmStore>, default: V128, mutable: bool) -> Option<Gd<Self>> {
    //     return Self::new_global(store, ValType::V128, mutable, V128(default));
    // }

    // TODO: ValType::Ref

    /// Get's the value of the Global.
    #[func]
    fn get(&mut self) -> Variant {
        match self.global.get(&mut self.store.bind_mut().store) {
            I32(value) => Variant::from(value),
            I64(value) => Variant::from(value),
            F32(value) => Variant::from(f32::from_bits(value)),
            F64(value) => Variant::from(f64::from_bits(value)),
            V128(_value) => todo!(),
            FuncRef(_value) => todo!(),
            ExternRef(_value) => todo!(),
            AnyRef(_value) => todo!(),
            ExnRef(_value) => todo!(),
            ContRef(_value) => todo!(),
        }
    }

    #[func]
    fn get_type_string(&mut self) -> GString {
        let global_type = self.global.ty(&mut self.store.bind_mut().store);
        return format!("{}", global_type.content()).as_str().into();
    }

    #[func]
    fn is_mutable(&mut self) -> bool {
        let global_type = self.global.ty(&mut self.store.bind_mut().store);
        return global_type.mutability() == Mutability::Var;
    }

    /// Returns `false` when invalid value is set, along with a logged error.
    #[func]
    fn set(&mut self, value: Variant) -> MyGodotResult<bool> {
        let global_type = self.global.ty(&mut self.store.bind_mut().store);
        let val = global_type.content().val_from(value)
            .or_godot_error("Failed to convert Variant:", false)?;
        self.global.set(&mut self.store.bind_mut().store, val)
            .or_godot_error("Failed to set global:", false)?;
        return Ok(true);
    }

    #[func]
    fn same_as(&mut self, other: Gd<WasmGlobal>) -> bool {
        return self.store.bind().same_as_(&other.bind().store.bind()) && self.global.debug_index_in_store() == other.bind().global.debug_index_in_store();
    }
}
