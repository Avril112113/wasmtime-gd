use godot::prelude::*;
use wasmtime::{FuncType, TagType};

use crate::{active_context::WasmContext, store_same_as::ContextStoreSameAs, to_from_variant::ToFromVariant, utils_errors::{IntoMyGodotResult, MyGodotResult}};
use super::WasmAsExtern;


/// A Wasmtime Extern::Tag
/// 
/// Note: A simple `==` between [WasmTag] is not enough.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmTag {
	pub tag: wasmtime::Tag,
	context: WasmContext,
}

#[godot_dyn]
impl WasmAsExtern for WasmTag {
	fn as_extern(&self) -> wasmtime::Extern {
		return wasmtime::Extern::Tag(self.tag);
	}
}

#[godot_api]
impl IRefCounted for WasmTag {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmTag.new() is invalid!");
	}
}

#[godot_api]
impl WasmTag {
	pub fn new_from(tag: wasmtime::Tag, context: WasmContext) -> Gd<Self> {
		// Callee may expect `context` to not be bound to during this call.
		return Gd::from_object(WasmTag {
			tag,
			context,
		})
	}

	/// Create a new [WasmTag] in the given [param context] with the given [param func_type] [br]
	/// [param context] can be one of; [WasmStore] or [WasmCaller]
	#[func]
	fn new_tag(&self, context: WasmContext, func_type: Array<Variant>) -> MyGodotResult<Option<Gd<WasmTag>>> {
		let mut ctx = self.context.as_context_mut();

		let func_type = FuncType::from_variant(ctx.engine(), &func_type.to_variant())
			.or_godot_error("*Invalid func_type", None)?;
	
		let tag_type = TagType::new(func_type);
		let tag = wasmtime::Tag::new(&mut ctx, &tag_type)
			.or_godot_error("Failed to create tag", None)?;

		return Ok(Some(WasmTag::new_from(
			tag,
			context
		)));
	}

	/// Returns the underlying type of this tag, including its element type as well as the maximum/minimum lower bounds.
	#[func]
	pub fn get_tag_type(&self) -> Variant {
		return self.tag.ty(self.context.as_context()).to_variant();
	}

	/// Check if 2 [WasmTag]s are actually the same tag.
	/// Note that, many separate [WasmTag] objects can refer to the same tag!
    #[func]
	fn same_as(&mut self, other: Gd<WasmTag>) -> bool {
		let other = other.bind();
		let context_self = self.context.as_context();
		let context_other = other.context.as_context();
		return context_self.same_store_as(&context_other) && self.tag.debug_index_in_store() == other.tag.debug_index_in_store();
	}
}
