use godot::prelude::*;
use wasmtime::{GlobalType, Mutability, Val::*, ValType};

use crate::{active_context::WasmContext, store_same_as::ContextStoreSameAs, to_from_variant::ToFromVariant, utils_errors::*, wasm_types::{ValFromVariantByValType, gd_wasm_func::WasmFunc}};
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
	context: WasmContext,
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
	pub fn new_from(global: wasmtime::Global, context: WasmContext) -> Gd<Self> {
		return Gd::from_object(Self {
			global,
			context,
		})
	}

	// TODO: Move godot new methods to the [WasmStore] impl.
	//       store.create_global(WasmGlobal.CONST, WasmGlobal.I32, 404)

	fn new_global(context: WasmContext, val_type: ValType, mutable: bool, default: wasmtime::Val) -> Option<Gd<Self>> {
		let global_type = GlobalType::new(val_type, if mutable {Mutability::Var} else {Mutability::Const});
		let global = wasmtime::Global::new(&mut context.as_context_mut(), global_type, default)
			.or_print_error("Failed to create Global:")?;
		return Some(Gd::from_object(Self {
			global,
			context,
		}));
	}

	/// Create a new [WasmGlobal] which contains a i32.
	#[func]
	fn new_i32(context: WasmContext, default: i32, mutable: bool) -> Option<Gd<Self>> {
		return Self::new_global(context, ValType::I32, mutable, I32(default));
	}

	/// Create a new [WasmGlobal] which contains a i64.
	#[func]
	fn new_i64(context: WasmContext, default: i64, mutable: bool) -> Option<Gd<Self>> {
		return Self::new_global(context, ValType::I64, mutable, I64(default));
	}

	/// Create a new [WasmGlobal] which contains a f32.
	#[func]
	fn new_f32(context: WasmContext, default: f32, mutable: bool) -> Option<Gd<Self>> {
		return Self::new_global(context, ValType::F32, mutable, F32(default.to_bits()));
	}

	/// Create a new [WasmGlobal] which contains a f64.
	#[func]
	fn new_f64(context: WasmContext, default: f64, mutable: bool) -> Option<Gd<Self>> {
		return Self::new_global(context, ValType::F64, mutable, F64(default.to_bits()));
	}

	// TODO
	// #[func]
	// fn new_v128(store: Gd<WasmStore>, default: V128, mutable: bool) -> Option<Gd<Self>> {
	//     return Self::new_global(store, ValType::V128, mutable, V128(default));
	// }

	/// Returns the global type. The contents may change in the future, only pass this value back to wasmtime-gd.
	#[func]
	fn get_global_type(&mut self) -> Variant {
		return self.global.ty(self.context.as_context()).to_variant();
	}

	// TODO: ValType::Ref

	/// Get's the value of the Global.
	#[func]
	fn get_value(&mut self) -> Variant {
		match self.global.get(self.context.as_context_mut()) {
			I32(value) => Variant::from(value),
			I64(value) => Variant::from(value),
			F32(value) => Variant::from(f32::from_bits(value)),
			F64(value) => Variant::from(f64::from_bits(value)),
			V128(_value) => todo!(),
			FuncRef(value) => value.map_or_else(Variant::nil, |value| WasmFunc::new_from(value, self.context.clone()).to_variant()),
			ExternRef(_value) => todo!(),
			AnyRef(_value) => todo!(),
			ExnRef(_value) => todo!(),
			ContRef(_value) => todo!(),
		}
	}

	/// If this global can be changed.
	#[func]
	fn is_mutable(&mut self) -> bool {
		let global_type = self.global.ty(self.context.as_context());
		return global_type.mutability() == Mutability::Var;
	}

	/// Set the value of this global, make sure to check [param is_mutable] [br]
	/// Returns `false` when invalid value is set, along with a logged error.
	#[func]
	fn set_value(&mut self, value: Variant) -> MyGodotResult<bool> {
		let mut context = self.context.as_context_mut();

		let global_type = self.global.ty(&self.context.as_context());
		let val = global_type.content().val_from(value, &mut context)
			.or_godot_error("Failed to convert Variant:", false)?;
		self.global.set(&mut context, val)
			.or_godot_error("Failed to set global:", false)?;
		return Ok(true);
	}

	/// Check if 2 [WasmGlobal]s are actually the same memory.
	/// Note that, many separate [WasmGlobal] objects can refer to the same memory!
	#[func]
	fn same_as(&mut self, other: Gd<WasmGlobal>) -> bool {
		let other = other.bind();
		let context_self = self.context.as_context();
		let context_other = other.context.as_context();
		return context_self.same_store_as(&context_other) && self.global.debug_index_in_store() == other.global.debug_index_in_store();
	}
}
