use godot::prelude::*;

use super::ToFromVariant;


impl ToFromVariant for wasmtime::HeapType {
	fn to_variant(&self) -> Variant {
		match self {
			wasmtime::HeapType::Extern => "extern".to_variant(),
			wasmtime::HeapType::NoExtern => "no_extern".to_variant(),

			wasmtime::HeapType::Func => "func".to_variant(),
			wasmtime::HeapType::NoFunc => "no_func".to_variant(),
			wasmtime::HeapType::ConcreteFunc(func_type) => func_type.to_variant(),
			
			wasmtime::HeapType::Array => "array".to_variant(),
			wasmtime::HeapType::ConcreteArray(_array_type) => todo!(),

			wasmtime::HeapType::Struct => "struct".to_variant(),
			wasmtime::HeapType::ConcreteStruct(_struct_type) => todo!(),

			wasmtime::HeapType::Exn => "exn".to_variant(),
			wasmtime::HeapType::NoExn => "no_exn".to_variant(),
			wasmtime::HeapType::ConcreteExn(_exn_type) => todo!(),

			wasmtime::HeapType::Cont => "cont".to_variant(),
			wasmtime::HeapType::NoCont => "no_cont".to_variant(),
			wasmtime::HeapType::ConcreteCont(_cont_type) => todo!(),

			wasmtime::HeapType::Any => "any".to_variant(),
			wasmtime::HeapType::None => "none".to_variant(),

			wasmtime::HeapType::Eq => "eq".to_variant(),
			wasmtime::HeapType::I31 => "i31".to_variant(),
		}
	}

	fn from_variant(_engine: &wasmtime::Engine, variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let str = variant.try_to::<GString>()?;
		match str.to_string().as_str() {
			"extern" => Ok(wasmtime::HeapType::Extern),
			"no_extern" => Ok(wasmtime::HeapType::NoExtern),
			"func" => Ok(wasmtime::HeapType::Func),
			"no_func" => Ok(wasmtime::HeapType::NoFunc),
			"array" => Ok(wasmtime::HeapType::Array),
			"struct" => Ok(wasmtime::HeapType::Struct),
			"exn" => Ok(wasmtime::HeapType::Exn),
			"no_exn" => Ok(wasmtime::HeapType::NoExn),
			"cont" => Ok(wasmtime::HeapType::Cont),
			"no_cont" => Ok(wasmtime::HeapType::NoCont),
			"any" => Ok(wasmtime::HeapType::Any),
			"none" => Ok(wasmtime::HeapType::None),
			"eq" => Ok(wasmtime::HeapType::Eq),
			"i31" => Ok(wasmtime::HeapType::I31),
			_ => Err(ConvertError::new("Invalid WASM type string")),
		}
	}
}