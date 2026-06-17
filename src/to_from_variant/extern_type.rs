use godot::prelude::*;

use super::ToFromVariant;


// NOTE: Any changes here may need to be reflected in `wasm_types.gd``
impl ToFromVariant for wasmtime::ExternType {
	fn to_variant(&self) -> Variant {
		match self {
			wasmtime::ExternType::Func(func_type) => func_type.to_variant(),
			wasmtime::ExternType::Global(global_type) => global_type.to_variant(),
			wasmtime::ExternType::Table(table_type) => table_type.to_variant(),
			wasmtime::ExternType::Memory(memory_type) => memory_type.to_variant(),
			wasmtime::ExternType::Tag(tag_type) => tag_type.to_variant(),
		}
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		if let Ok(func_type) = wasmtime::FuncType::from_variant(engine, variant) {
			return Ok(wasmtime::ExternType::Func(func_type));
		}

		return Err(ConvertError::new("Invalid WASM type composition"));
	}
}
