use godot::prelude::*;
use wasmtime::{Val::*, ValType};


pub trait ValFromVariantByValType {
	fn val_from(&self, variant: Variant) -> Result<wasmtime::Val, ConvertError>;
}

impl ValFromVariantByValType for ValType {
	fn val_from(&self, variant: Variant) -> Result<wasmtime::Val, ConvertError> {
		return Ok(match self {
			ValType::I32 => I32(variant.try_to()?),
			ValType::I64 => I64(variant.try_to()?),
			ValType::F32 => F32(variant.try_to()?),
			ValType::F64 => F32(variant.try_to()?),
			ValType::V128 => todo!(),
			ValType::Ref(_ref_type) => todo!(),
		});
	}
}

pub trait ValIntoVariant {
	fn into_variant(&self) -> Variant;
}

impl ValIntoVariant for wasmtime::Val {
	fn into_variant(&self) -> Variant {
		match self {
			I32(value) => Variant::from(*value),
			I64(value) => Variant::from(*value),
			F32(value) => Variant::from(f32::from_bits(*value)),
			F64(value) => Variant::from(f64::from_bits(*value)),
			V128(_v128) => todo!(),
			FuncRef(_func) => todo!(),
			ExternRef(_rooted) => todo!(),
			AnyRef(_rooted) => todo!(),
			ExnRef(_rooted) => todo!(),
			ContRef(_cont_ref) => todo!(),
		}
	}
}
