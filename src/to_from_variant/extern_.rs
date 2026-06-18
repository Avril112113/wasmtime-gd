use godot::prelude::*;

use crate::{to_from_variant::to_from_godot::ToFromVariantContext, utils::GdAsContext, wasm_types::{WasmAsExtern, gd_wasm_func::WasmFunc, gd_wasm_global::WasmGlobal, gd_wasm_memory::WasmMemory}};



impl ToFromVariantContext for wasmtime::Extern {
	fn to_variant(&self, context: DynGd<RefCounted, dyn GdAsContext>) -> Variant {
		match self {
			wasmtime::Extern::Func(func) => WasmFunc::new_from(*func, context).to_variant(),
			wasmtime::Extern::Global(global) => WasmGlobal::new_from(*global, context).to_variant(),
			wasmtime::Extern::Table(_table) => todo!(),
			wasmtime::Extern::Memory(memory) => WasmMemory::new_from(*memory, context).to_variant(),
			wasmtime::Extern::SharedMemory(_shared_memory) => todo!(),
			wasmtime::Extern::Tag(_tag) => todo!(),
		}
	}

	fn from_variant(variant: &Variant) -> Result<Self, ConvertError> where Self: Sized {
		let gd_extern = variant.try_to::<DynGd<RefCounted, dyn WasmAsExtern>>()?;
		return Ok(gd_extern.dyn_bind().as_extern());
	}
}
