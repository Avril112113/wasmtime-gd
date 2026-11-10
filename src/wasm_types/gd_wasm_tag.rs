use godot::prelude::*;
use wasmtime::{FuncType, TagType};

use crate::{store_same_as::ContextStoreSameAs, to_from_variant::ToFromVariant, utils::GdAsContext, utils_errors::{IntoMyGodotResult, MyGodotResult}};
use super::WasmAsExtern;


/// A Wasmtime Extern::Tag
/// 
/// Note: A simple `==` between [WasmTag] is not enough.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmTag {
	pub tag: wasmtime::Tag,
	context: DynGd<RefCounted, dyn GdAsContext>,
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
	pub fn new_from(tag: wasmtime::Tag, context: DynGd<RefCounted, dyn GdAsContext>) -> Gd<Self> {
		// Callee may expect `context` to not be bound to during this call.
		return Gd::from_object(WasmTag {
			tag,
			context,
		})
	}

	#[func]
	fn new_tag(&self, mut context: DynGd<RefCounted, dyn GdAsContext>, func_type: Array<Variant>) -> MyGodotResult<Option<Gd<WasmTag>>> {
		let gd_context = context.dyn_bind_mut();

		let func_type = FuncType::from_variant(gd_context.as_context_mut().engine(), &func_type.to_variant())
			.or_godot_error("*Invalid func_type", None)?;
	
		let tag_type = TagType::new(func_type);
		let tag = wasmtime::Tag::new(&mut gd_context.as_context_mut(), &tag_type)
			.or_godot_error("Failed to create tag", None)?;

		drop(gd_context);
		
		return Ok(Some(WasmTag::new_from(
			tag,
			context
		)));
	}

	/// Returns the underlying type of this table, including its element type as well as the maximum/minimum lower bounds.
	#[func]
	pub fn get_tag_type(&self) -> Variant {
		return self.tag.ty(&mut self.context.dyn_bind().as_context()).to_variant();
	}

	/// Check if 2 [WasmTag]s are actually the same table.
	/// Note that, many separate [WasmTag] objects can refer to the same table!
    #[func]
    fn same_as(&mut self, other: Gd<WasmTag>) -> bool {
        return self.context.dyn_bind().as_context().same_store_as(&other.bind().context.dyn_bind().as_context()) && self.tag.debug_index_in_store() == other.bind().tag.debug_index_in_store();
    }
}
