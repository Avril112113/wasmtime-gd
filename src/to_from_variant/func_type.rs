use godot::prelude::*;

use super::ToFromVariant;


// NOTE: Any changes here may need to be reflected in `wasm_types.gd``
impl ToFromVariant for wasmtime::FuncType {
	fn to_variant(&self) -> Variant {
		let mut array = Array::new();
		array.push("func_type");
		array.push(&Array::from_iter(self.params().map(|ty| ty.to_variant())).to_variant());
		array.push(&Array::from_iter(self.results().map(|ty| ty.to_variant())).to_variant());
		return array.to_variant();
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let array = variant.try_to::<Array<Variant>>()?;

		if array.len() != 3 {
			return Err(ConvertError::new("Expected array length of 3"));
		}
		
		match array.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "func_type" {
					return Err(ConvertError::new("Expected array[0] == \"func_type\""))
				}
			},
			Err(err) => return Err(err),
		};

		let params_array = array.at(1).try_to::<Array<Variant>>()?;
		let results_array = array.at(2).try_to::<Array<Variant>>()?;

		let params = params_array.iter_shared()
			.enumerate()
			.map(|(i, v)|
				wasmtime::ValType::from_variant(engine, &v).map_err(|err| ConvertError::new(format!("result type {}: {}", i, err)))
			)
			.collect::<Result<Vec<wasmtime::ValType>, ConvertError>>()?;
		
		let results = results_array.iter_shared()
			.enumerate()
			.map(|(i, v)|
				wasmtime::ValType::from_variant(engine, &v).map_err(|err| ConvertError::new(format!("result type {}: {}", i, err)))
			)
			.collect::<Result<Vec<wasmtime::ValType>, ConvertError>>()?;

		return Ok(wasmtime::FuncType::new(engine, params, results));
	}
}