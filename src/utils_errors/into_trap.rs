pub(crate) trait IntoTrap<TRes> {
	fn into_trap(self, msg: &str) -> Result<TRes,wasmtime::Error>;
}

impl<TRes> IntoTrap<TRes> for Result<TRes,godot::prelude::ConvertError> {
	fn into_trap(self, msg: &str) -> Result<TRes,wasmtime::Error> {
		return self.map_err(|err| wasmtime::Error::msg(format!("{}: {}", msg, err)));
	}
}
