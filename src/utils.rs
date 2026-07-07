use crate::store_data::StoreData;

pub trait GdAsContext {
	fn as_context(&self) -> wasmtime::StoreContext<'_, StoreData>;
	fn as_context_mut(&mut self) -> wasmtime::StoreContextMut<'_, StoreData>;
}
