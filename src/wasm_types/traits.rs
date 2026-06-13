pub trait WasmAsExtern {
	fn as_extern(&self) -> wasmtime::Extern;
}
