use godot::prelude::*;

use crate::utils_errors::IntoMyGodotOption;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::TableType {
	fn to_variant(&self) -> Variant {
		let mut array = Array::new();
		array.push("table");
		array.push(&self.element().to_variant());
		array.push(self.is_64());
		array.push(self.minimum().try_into().unwrap_or_else(|err| {
			Err::<(), _>(err).or_print_error("TableType minimum did not fit into i64, it has been truncated to i64::Max");
			return i64::MAX;
		}));
		if let Some(maximum) = self.maximum() {
			array.push(maximum.try_into().unwrap_or_else(|err| {
				Err::<(), _>(err).or_print_error("TableType maximum did not fit into i64, it has been truncated to i64::Max");
				return i64::MAX;
			}));
		}
		return array.to_variant();
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let array = variant.try_to::<Array<Variant>>()?;

		let array_len = array.len();
		if array_len != 4 || array_len != 5 {
			return Err(ConvertError::new("Expected array length of 4 or 5"));
		}
		
		match array.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "table" {
					return Err(ConvertError::new("Expected array[0] == \"table\""))
				}
			},
			Err(err) => return Err(err),
		};

		if array.at(2).try_to()? {
			return Ok(wasmtime::TableType::new64(
				wasmtime::RefType::from_variant(engine, &array.at(1))?,
				i64::try_from_variant(&array.at(3))? as u64,
				if array_len == 5 {Some(i64::try_from_variant(&array.at(4))? as u64)} else {None}
			));
		} else {
			return Ok(wasmtime::TableType::new(
				wasmtime::RefType::from_variant(engine, &array.at(1))?,
				i64::try_from_variant(&array.at(3))? as u32,
				if array_len == 5 {Some(i64::try_from_variant(&array.at(4))? as u32)} else {None}
			));
		}
	}
}