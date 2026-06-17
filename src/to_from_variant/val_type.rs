use godot::prelude::*;

use super::ToFromVariant;


// NOTE: Any changes here may need to be reflected in `wasm_types.gd``
impl ToFromVariant for wasmtime::ValType {
	fn to_variant(&self) -> Variant {
		match self {
			wasmtime::ValType::I32 => "i32".to_variant(),
			wasmtime::ValType::I64 => "i64".to_variant(),
			wasmtime::ValType::F32 => "f32".to_variant(),
			wasmtime::ValType::F64 => "f64".to_variant(),
			wasmtime::ValType::V128 => "v128".to_variant(),
			wasmtime::ValType::Ref(ref_type) => ref_type.to_variant(),
		}
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> {
		return match variant.get_type() {
			VariantType::STRING => match variant.to::<GString>().to_string().as_str() {
				"i32" => Ok(wasmtime::ValType::I32),
				"i64" => Ok(wasmtime::ValType::I64),
				"f32" => Ok(wasmtime::ValType::F32),
				"f64" => Ok(wasmtime::ValType::F64),
				"v128" => Ok(wasmtime::ValType::V128),
				
				_ => Err(ConvertError::new("Invalid WASM type string")),
			},
			VariantType::ARRAY => Ok(wasmtime::ValType::Ref(wasmtime::RefType::from_variant(engine, variant)?)),
			_ => Err(ConvertError::new("Invalid WASM type composition")),
		};
	}
}
