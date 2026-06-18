use godot::prelude::*;

use crate::utils::GdAsContext;


pub trait ToFromVariant {
	fn to_variant(&self) -> Variant;
	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}

pub trait ToFromVariantContext {
	fn to_variant(&self, context: DynGd<RefCounted, dyn GdAsContext>) -> Variant;
	fn from_variant(variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}
