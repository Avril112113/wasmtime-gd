use godot::prelude::*;

use crate::active_context::WasmContext;


pub trait ToFromVariant {
	fn to_variant(&self) -> Variant;
	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}

pub trait ToFromVariantContext {
	fn to_variant(&self, context: &WasmContext) -> Variant;
	fn from_variant(variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}
