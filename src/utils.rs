pub trait GdAsContext {
	fn as_context(&self) -> wasmtime::StoreContext<'_, ()>;
	fn as_context_mut(&mut self) -> wasmtime::StoreContextMut<'_, ()>;
}
