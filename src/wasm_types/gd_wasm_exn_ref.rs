use godot::prelude::*;
use wasmtime::Rooted;

use crate::{utils::GdAsContext, utils_errors::{IntoMyGodotResult, MyGodotResult}, wasm_types::{ValToVariant, gd_wasm_tag::WasmTag}};


/// A Wasmtime Extern::ExnRef
/// 
/// Note: A simple `==` between [WasmExnRef] is not enough.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmExnRef {
	pub exn_ref: Rooted<wasmtime::ExnRef>,
	context: DynGd<RefCounted, dyn GdAsContext>,
}

#[godot_api]
impl IRefCounted for WasmExnRef {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmExnRef.new() is invalid!");
	}
}

#[godot_api]
impl WasmExnRef {
	pub fn new_from(exn_ref: Rooted<wasmtime::ExnRef>, context: DynGd<RefCounted, dyn GdAsContext>) -> Gd<Self> {
		// Callee may expect `context` to not be bound to during this call.
		return Gd::from_object(WasmExnRef {
			exn_ref,
			context,
		})
	}

	// TODO: A way for Godot to create these.

	// /// Returns the underlying type of this exception reference, including its element type as well as the maximum/minimum lower bounds.
	// #[func]
	// pub fn get_exn_type(&self) -> MyGodotResult<Variant> {
	// 	return self.exn_ref.ty(&mut self.context.dyn_bind().as_context())
	// 		.or_godot_error("ExnRef has been freed.", Variant::nil())?
	// 		.to_variant();
	// }

	/// Returns the underlying type of this exception reference, including its element type as well as the maximum/minimum lower bounds.
	#[func]
	pub fn get_tag(&self) -> MyGodotResult<Option<Gd<WasmTag>>> {
		let tag = self.exn_ref.tag(self.context.clone().dyn_bind_mut().as_context_mut())
			.or_godot_error("ExnRef has been freed.", None)?;
		return Ok(Some(WasmTag::new_from(tag, self.context.clone())));
	}

	#[func]
	pub fn get_fields(&mut self) -> MyGodotResult<Variant> {
		let mut context = self.context.clone();
		let context = context.dyn_bind_mut();
		let mut context = context.as_context_mut();

		let fields = self.exn_ref.fields(&mut context)
			.or_godot_error("ExnRef has been freed.", Variant::nil())?;

		let mut array = Array::new();

		for field in fields {
			array.push(&field.to_variant(self.context.clone()));
		}

		return Ok(array.to_variant());
	}
}
