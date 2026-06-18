use godot::prelude::*;

use crate::gd_script_stuff::GDScriptStuff;


#[derive(Debug)]
pub struct WasmGodotError {
	pub msg: String,
	pub data: fragile::Fragile<Variant>,
}

impl std::error::Error for WasmGodotError {}

impl std::fmt::Display for WasmGodotError {
	fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
		write!(f, "GodotError: {}", self.msg)
	}
}


/// [WasmError] can only be used once, it must be discarded once passed into WasmtimeGd.
/// You may use [member is_taken] to check if this [WasmError] is still valid.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmError {
	pub error: Option<wasmtime::Error>,
}

#[godot_api]
impl IRefCounted for WasmError {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmError.new() is invalid!");
	}
}

#[godot_api]
impl WasmError {
	pub fn new_from_error(error: wasmtime::Error) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(error),
		});
	}

	#[func]
	fn new_from(msg: GString, data: Variant) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(wasmtime::Error::new(WasmGodotError {
				msg: msg.to_string(),
				data: fragile::Fragile::new(data)
			})),
		});
	}

	#[func]
	fn is_taken(&self) -> bool {
		return self.error.is_none();
	}

	#[func]
	fn print(&self) {
		if let Some(error) = &self.error {
			GDScriptStuff::print_error(&error.to_string(), None);
		} else {
			GDScriptStuff::print_error("Attempt to print WasmError which has already been taken.", None);
		}
	}
}
