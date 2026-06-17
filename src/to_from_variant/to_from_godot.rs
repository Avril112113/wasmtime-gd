use godot::prelude::*;


pub trait ToFromVariant {
	fn to_variant(&self) -> Variant;
	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}
