use godot::prelude::*;


pub trait ValTypeGodot {
	fn to_variant(&self) -> Variant;
	fn from_variant(engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized;
}

// NOTE: Any changes here may need to be reflected in `wasm_types.gd``
impl ValTypeGodot for wasmtime::ValType {
	fn to_variant(&self) -> Variant {
		match self {
			wasmtime::ValType::I32 => "i32".to_variant(),
			wasmtime::ValType::I64 => "i64".to_variant(),
			wasmtime::ValType::F32 => "f32".to_variant(),
			wasmtime::ValType::F64 => "f64".to_variant(),
			wasmtime::ValType::V128 => "v128".to_variant(),
			wasmtime::ValType::Ref(ref_type) => {
				let nullable = ref_type.is_nullable();
				match ref_type.heap_type() {
					wasmtime::HeapType::Extern => if nullable { "extern?".to_variant() } else { "extern".to_variant() },
					wasmtime::HeapType::NoExtern => if nullable { "no_extern?".to_variant() } else { "no_extern".to_variant() },

					wasmtime::HeapType::Func => if nullable { "func?".to_variant() } else { "func".to_variant() },
					wasmtime::HeapType::NoFunc => if nullable { "no_func?".to_variant() } else { "no_func".to_variant() },
					wasmtime::HeapType::ConcreteFunc(func_type) => func_type.to_variant(),
					
					wasmtime::HeapType::Array => if nullable { "array?".to_variant() } else { "array".to_variant() },
					wasmtime::HeapType::ConcreteArray(_array_type) => todo!(),

					wasmtime::HeapType::Struct => if nullable { "struct?".to_variant() } else { "struct".to_variant() },
					wasmtime::HeapType::ConcreteStruct(_struct_type) => todo!(),

					wasmtime::HeapType::Exn => if nullable { "exn?".to_variant() } else { "exn".to_variant() },
					wasmtime::HeapType::NoExn => if nullable { "no_exn?".to_variant() } else { "no_exn".to_variant() },
					wasmtime::HeapType::ConcreteExn(_exn_type) => todo!(),

					wasmtime::HeapType::Cont => if nullable { "cont?".to_variant() } else { "cont".to_variant() },
					wasmtime::HeapType::NoCont => if nullable { "no_cont?".to_variant() } else { "no_cont".to_variant() },
					wasmtime::HeapType::ConcreteCont(_cont_type) => todo!(),

					wasmtime::HeapType::Any => if nullable { "any?".to_variant() } else { "any".to_variant() },
					wasmtime::HeapType::None => if nullable { "none?".to_variant() } else { "none".to_variant() },

					wasmtime::HeapType::Eq => if nullable { "eq?".to_variant() } else { "eq".to_variant() },
					wasmtime::HeapType::I31 => if nullable { "i31?".to_variant() } else { "i31".to_variant() },
				}
			}
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
				
				"extern" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Extern))),
				"extern?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Extern))),
				"no_extern" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::NoExtern))),
				"no_extern?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::NoExtern))),
				
				"func" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Func))),
				"func?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Func))),
				"no_func" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::NoFunc))),
				"no_func?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::NoFunc))),
				
				"array" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Array))),
				"array?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Array))),
				
				"struct" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Struct))),
				"struct?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Struct))),
				
				"exn" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Exn))),
				"exn?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Exn))),
				"no_exn" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::NoExn))),
				"no_exn?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::NoExn))),
				
				"cont" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Cont))),
				"cont?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Cont))),
				"no_cont" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::NoCont))),
				"no_cont?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::NoCont))),

				"any" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Any))),
				"any?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Any))),
				"none" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::None))),
				"none?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::None))),
				
				"eq" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::Eq))),
				"eq?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::Eq))),
				"i31" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(false, wasmtime::HeapType::I31))),
				"i31?" => Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::I31))),
				
				_ => Err(ConvertError::new("Invalid WASM type string")),
			},
			VariantType::ARRAY => {
				if let Ok(func_type) = wasmtime::FuncType::from_variant(engine, variant) {
					return Ok(wasmtime::ValType::Ref(wasmtime::RefType::new(true, wasmtime::HeapType::ConcreteFunc(func_type))));
				}
				Err(ConvertError::new("Invalid WASM type composition"))
			},
			_ => Err(ConvertError::new("Invalid WASM type composition")),
		};
	}
}

// NOTE: Any changes here may need to be reflected in `wasm_types.gd``
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
