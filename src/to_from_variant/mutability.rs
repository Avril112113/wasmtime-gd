use godot::prelude::*;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::Mutability {
	fn to_variant(&self) -> Variant {
		match self {
			wasmtime::Mutability::Const => "const".to_variant(),
			wasmtime::Mutability::Var => "var".to_variant(),
		}
	}

	fn from_variant(_engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let str = variant.try_to::<GString>()?.to_string();
		match str.as_str() {
			"const" => Ok(wasmtime::Mutability::Const),
			"var" => Ok(wasmtime::Mutability::Var),
			_ => Err(ConvertError::new("Invalid mutability, expected \"const\" or \"var\""))
		}
	}
}