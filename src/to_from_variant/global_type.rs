use godot::prelude::*;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::GlobalType {
	fn to_variant(&self) -> Variant {
		let mut array = Array::new();
		array.push("global_type");
		array.push(&self.mutability().to_variant());
		array.push(&self.content().to_variant());
		return array.to_variant();
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let array = variant.try_to::<Array<Variant>>()?;

		if array.len() != 3 {
			return Err(ConvertError::new("Expected array length of 3"));
		}
		
		match array.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "global_type" {
					return Err(ConvertError::new("Expected array[0] == \"global_type\""))
				}
			},
			Err(err) => return Err(err),
		};

		return Ok(wasmtime::GlobalType::new(
			wasmtime::ValType::from_variant(engine, &array.at(2))?,
			wasmtime::Mutability::from_variant(engine, &array.at(1))?
		));
	}
}