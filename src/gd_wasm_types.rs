use godot::prelude::*;


pub trait ValTypeGodot {
	fn to_variant(&self) -> Variant;
	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}

impl ValTypeGodot for wasmtime::FuncType {
	fn to_variant(&self) -> Variant {
		let mut array = Array::new();
		array.push("func");
		array.push(&Array::from_iter(self.params().map(|ty| ty.to_variant())).to_variant());
		array.push(&Array::from_iter(self.results().map(|ty| ty.to_variant())).to_variant());
		return array.to_variant();
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let func_def = variant.try_to::<Array<Variant>>()?;

		if func_def.len() != 3 {
			return Err(ConvertError::new("Expected array length of 3"));
		}
		
		match func_def.at(0).try_to::<GString>() {
			Ok(def_name) => {
				if def_name.to_string().as_str() != "" {
					return Err(ConvertError::new("Expected array[0] == \"func\""))
				}
			},
			Err(err) => return Err(err),
		};

		let params_array = func_def.at(1).try_to::<Array<Variant>>()?;
		let results_array = func_def.at(2).try_to::<Array<Variant>>()?;

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

impl ValTypeGodot for wasmtime::ValType {
	fn to_variant(&self) -> Variant {
		match self {
			wasmtime::ValType::I32 => "i32".to_variant(),
			wasmtime::ValType::I64 => "i64".to_variant(),
			wasmtime::ValType::F32 => "f32".to_variant(),
			wasmtime::ValType::F64 => "f64".to_variant(),
			wasmtime::ValType::V128 => todo!(),
			wasmtime::ValType::Ref(ref_type) => match ref_type.heap_type() {
				wasmtime::HeapType::Extern => todo!(),
				wasmtime::HeapType::NoExtern => todo!(),
				wasmtime::HeapType::Func => "func".to_variant(),
				wasmtime::HeapType::ConcreteFunc(func_type) => func_type.to_variant(),
				wasmtime::HeapType::NoFunc => todo!(),
				wasmtime::HeapType::Any => todo!(),
				wasmtime::HeapType::Eq => todo!(),
				wasmtime::HeapType::I31 => todo!(),
				wasmtime::HeapType::Array => todo!(),
				wasmtime::HeapType::ConcreteArray(_array_type) => todo!(),
				wasmtime::HeapType::Struct => todo!(),
				wasmtime::HeapType::ConcreteStruct(_struct_type) => todo!(),
				wasmtime::HeapType::Exn => todo!(),
				wasmtime::HeapType::ConcreteExn(_exn_type) => todo!(),
				wasmtime::HeapType::ConcreteCont(_cont_type) => todo!(),
				wasmtime::HeapType::Cont => todo!(),
				wasmtime::HeapType::NoCont => todo!(),
				wasmtime::HeapType::None => todo!(),
				wasmtime::HeapType::NoExn => todo!(),
			},
		}
	}

	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> {
		return match variant.get_type() {
			VariantType::STRING => match variant.to::<GString>().to_string().to_lowercase().as_str() {
				"i32" => Ok(wasmtime::ValType::I32),
				"i64" => Ok(wasmtime::ValType::I64),
				"f32" => Ok(wasmtime::ValType::F32),
				"f64" => Ok(wasmtime::ValType::F64),
				"func" => Ok(wasmtime::ValType::FUNCREF),
				_ => Err(ConvertError::new("Invalid WASM type")),
			},
			_ => {
				if let Ok(func_type) = wasmtime::FuncType::from_variant(engine, variant) {
					return Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::ConcreteFunc(func_type))));
				}
				Err(ConvertError::new("Invalid WASM type"))
			},
		};
	}
}
