use godot::prelude::*;
use wasmtime::{AsContextMut, Extern, ExternRef, HeapType, RefType, Val, ValType};

use crate::{to_from_variant::to_from_godot::ToFromVariantContext, utils::GdAsContext, wasm_types::gd_wasm_func::WasmFunc};


pub trait ValFromVariantByValType {
	fn val_from(&self, variant: Variant, context: impl AsContextMut) -> Result<Val, ConvertError>;
}

impl ValFromVariantByValType for ValType {
	fn val_from(&self, variant: Variant, context: impl AsContextMut) -> Result<Val, ConvertError> {
		return Ok(match self {
			ValType::I32 => Val::I32(variant.try_to()?),
			ValType::I64 => Val::I64(variant.try_to()?),
			ValType::F32 => Val::F32(variant.try_to()?),
			ValType::F64 => Val::F32(variant.try_to()?),
			ValType::V128 => todo!(),
			ValType::Ref(ref_type) => ref_type.val_from(variant, context)?,
		});
	}
}

impl ValFromVariantByValType for RefType {
	fn val_from(&self, variant: Variant, context: impl AsContextMut) -> Result<Val, ConvertError> {
		if variant.is_nil() {
			return Ok(Val::null_ref(self.heap_type()));
		}
		
		return Ok(match self.heap_type() {
			HeapType::Extern | HeapType::NoExtern
				=> Val::ExternRef(Some(ExternRef::new(context, Extern::from_variant(&variant)?).expect("TODO: Handle wasmtime::Error"))),
			HeapType::Func | HeapType::ConcreteFunc(_) | HeapType::NoFunc
				=> Val::FuncRef(Some(variant.try_to::<Gd<WasmFunc>>()?.bind().func)),
			HeapType::Any => todo!("Any"),
			HeapType::Eq => todo!("Eq"),
			HeapType::I31 => todo!("I31"),
			HeapType::Array => todo!("Array"),
			HeapType::ConcreteArray(_array_type) => todo!("ConcreteArray"),
			HeapType::Struct => todo!("Struct"),
			HeapType::ConcreteStruct(_struct_type) => todo!("ConcreteStruct"),
			HeapType::Exn => todo!("Exn"),
			HeapType::ConcreteExn(_exn_type) => todo!("ConcreteExn"),
			HeapType::ConcreteCont(_cont_type) => todo!("ConcreteCont"),
			HeapType::Cont => todo!("Cont"),
			HeapType::NoCont => todo!("NoCont"),
			HeapType::None => todo!("None"),
			HeapType::NoExn => todo!("NoExn"),
		});
	}
}

pub trait ValToVariant {
	fn to_variant(&self, context: DynGd<RefCounted, dyn GdAsContext>) -> Variant;
}

impl ValToVariant for Val {
	fn to_variant(&self, context: DynGd<RefCounted, dyn GdAsContext>) -> Variant {
		match self {
			Val::I32(value) => Variant::from(*value),
			Val::I64(value) => Variant::from(*value),
			Val::F32(value) => Variant::from(f32::from_bits(*value)),
			Val::F64(value) => Variant::from(f64::from_bits(*value)),
			Val::V128(_v128) => todo!("V128"),
			Val::FuncRef(func) => match func {
				Some(func) => { WasmFunc::new_from(func.to_owned(), context).to_variant() },
				None => { Variant::nil() }
			},
			Val::ExternRef(_rooted) => todo!("ExternRef"),
			Val::AnyRef(_rooted) => todo!("AnyRef"),
			Val::ExnRef(_rooted) => todo!("ExnRef"),
			Val::ContRef(_cont_ref) => todo!("ContRef"),
		}
	}
}
