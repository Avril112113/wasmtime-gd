use godot::prelude::*;

use crate::utils_errors::IntoMyGodotOption;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::MemoryType {
	fn to_variant(&self) -> Variant {
		let mut array: Array<Variant> = Array::new();
		array.push("memory");
		array.push(self.is_64());
		array.push(self.is_shared());
		array.push(self.page_size_log2());
		array.push(self.minimum().try_into().unwrap_or_else(|err| {
			Err::<(), _>(err).or_print_error("MemoryType minimum did not fit into i64, it has been truncated to i64::Max");
			return i64::MAX;
		}));
		if let Some(maximum) = self.maximum() {
			array.push(maximum.try_into().unwrap_or_else(|err| {
				Err::<(), _>(err).or_print_error("MemoryType maximum did not fit into i64, it has been truncated to i64::Max");
				return i64::MAX;
			}));
		}
		return array.to_variant();
	}

	fn from_variant(_engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let array = variant.try_to::<Array<Variant>>()?;

		let array_len = array.len();
		if array_len != 5 || array_len != 6 {
			return Err(ConvertError::new("Expected array length of 5 or 6"));
		}
		
		match array.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "memory" {
					return Err(ConvertError::new("Expected array[0] == \"memory\""))
				}
			},
			Err(err) => return Err(err),
		};

		let mut builder = wasmtime::MemoryTypeBuilder::default();
		builder.memory64(array.at(1).try_to()?);
		builder.shared(array.at(2).try_to()?);
		builder.page_size_log2(array.at(4).try_to::<u8>()?);
		builder.min(array.at(5).try_to::<i64>()? as u64);
		builder.max(if array_len == 6 {Some(array.at(5).try_to::<i64>()? as u64)} else {None});
		return Ok(builder.build().unwrap());
	}
}