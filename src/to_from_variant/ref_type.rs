use godot::prelude::*;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::RefType {
	fn to_variant(&self) -> Variant {
		let mut array = Array::new();
		array.push("ref_type");
		array.push(self.is_nullable());
		array.push(&self.heap_type().to_variant());
		return array.to_variant();
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let array = variant.try_to::<Array<Variant>>()?;

		if array.len() != 3 {
			return Err(ConvertError::new("Expected array length of 3"));
		}
		
		match array.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "ref_type" {
					return Err(ConvertError::new("Expected array[0] == \"ref_type\""))
				}
			},
			Err(err) => return Err(err),
		};

		return Ok(wasmtime::RefType::new(
			bool::try_from_variant(&array.at(1))?,
			wasmtime::HeapType::from_variant(engine, &array.at(2))?
		));
	}
}