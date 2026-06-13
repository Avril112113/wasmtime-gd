pub(crate) trait IntoTrap<TRes> {
	fn into_trap(self) -> Result<TRes,wasmtime::Error>;
}

impl<TRes> IntoTrap<TRes> for Result<TRes,godot::prelude::ConvertError> {
	fn into_trap(self) -> Result<TRes,wasmtime::Error> {
		// .map_err(|err| wasmtime::Error::new(err))
		return self.map_err(|err| wasmtime::Error::msg(format!("{}", err)));
	}
}
