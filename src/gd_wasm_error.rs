use std::sync::atomic::AtomicBool;

use godot::prelude::*;

use crate::gd_script_stuff::GDScriptStuff;


static INCLUDE_RUST_BACKTRACE: AtomicBool = AtomicBool::new(false);


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
	#[var(get=get_data, no_set)]
	prop_data: PhantomVar<Variant>,
}

#[godot_api]
impl IRefCounted for WasmError {
	fn init(_base: Base<Self::Base>) -> Self {
		// Normally we'd panic on using this, but since we have a property, Godot creates a new one upon init.
		Self {
			error: Some(wasmtime::Error::new(WasmGodotError {
				msg: "Anonymous WasmError (avoid using `WasmError.new()`)".to_string(),
				data: fragile::Fragile::new(Variant::nil()),
			})),
			prop_data: PhantomVar::default(),
		}
	}
}

#[godot_api]
impl WasmError {
	pub fn new_from_error(error: wasmtime::Error) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(error),
			prop_data: PhantomVar::default(),
		});
	}

	#[func]
	fn new_from(msg: GString, data: Variant) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(wasmtime::Error::new(WasmGodotError {
				msg: msg.to_string(),
				data: fragile::Fragile::new(data),
			})),
			prop_data: PhantomVar::default(),
		});
	}

	#[func]
	fn is_taken(&self) -> bool {
		return self.error.is_none();
	}

	#[func]
	fn get_data(&self) -> Variant {
		if let Some(Some(error)) = self.error.as_ref().map(|error| error.downcast_ref::<WasmGodotError>()) {
			return error.data.get().to_variant();
		}
		return Variant::nil();
	}

	#[func]
	pub fn print(&self) {
		if let Some(error) = &self.error {
			let rust_backtrace = error.backtrace().to_string()
				.lines()
				.filter(|line| line.contains("wasmtime_gd"))
				.collect::<Vec<&str>>()
				.join("\n");
			if INCLUDE_RUST_BACKTRACE.load(std::sync::atomic::Ordering::Relaxed) {
				GDScriptStuff::print_error(&format!("WASM returned an error:\n{}\n{}\nRust Backtrace:\n{}", error.root_cause(), error, rust_backtrace), None);
			} else {
				GDScriptStuff::print_error(&format!("WASM returned an error:\n{}\n{}", error.root_cause(), error), None);
			}
		} else {
			GDScriptStuff::print_error("Attempt to print WasmError which has already been taken.", None);
		}
	}

	#[func]
	fn set_include_rust_backtrace(enabled: bool) {
		INCLUDE_RUST_BACKTRACE.store(enabled, std::sync::atomic::Ordering::Relaxed);
	}
}
