use godot::prelude::*;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::TagType {
	fn to_variant(&self) -> Variant {
		let mut array = Array::new();
		array.push("tag_type");
		array.push(&self.ty().to_variant());
		return array.to_variant();
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let array = variant.try_to::<Array<Variant>>()?;

		if array.len() != 2 {
			return Err(ConvertError::new("Expected array length of 2"));
		}
		
		match array.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "tag_type" {
					return Err(ConvertError::new("Expected array[0] == \"tag_type\""))
				}
			},
			Err(err) => return Err(err),
		};

		return Ok(wasmtime::TagType::new(
			wasmtime::FuncType::from_variant(engine, &array.at(1))?
		));
	}
}