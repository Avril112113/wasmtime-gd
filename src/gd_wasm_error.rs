use std::sync::atomic::AtomicBool;

use godot::{meta::AsArg, prelude::*};
use wasmtime::ThrownException;

use crate::{gd_script_stuff::GDScriptStuff, thread_safe_variant::ThreadVariant};


static INCLUDE_RUST_BACKTRACE: AtomicBool = AtomicBool::new(false);


#[derive(Debug)]
pub struct WasmGodotError {
	pub data: ThreadVariant,
}

impl WasmGodotError {
	pub fn new(data: impl AsArg<Variant>) -> Self {
		Self {
			data: ThreadVariant::new(data.into_arg().to_owned()),
		}
	}
}

impl std::error::Error for WasmGodotError {}

impl std::fmt::Display for WasmGodotError {
	fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
		write!(f, "GodotError: {}", self.data.get())
	}
}


#[derive(Debug)]
pub struct WasmAnyError {
	pub error: anyhow::Error,
}

impl WasmAnyError {
	pub fn new(error: anyhow::Error) -> Self {
		Self {
			error,
		}
	}
}

impl std::error::Error for WasmAnyError {}

impl std::fmt::Display for WasmAnyError {
	fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
		write!(f, "wasmtime-gd Error: {}", self.error)
	}
}


/// [WasmError] can only be used once, it must be discarded once passed into wasmtime-gd.
/// You may use [member is_taken] to check if this [WasmError] is still valid.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmError {
	pub error: Option<wasmtime::Error>,

	/// The value which was given to [member new_from]. [br]
	/// If the error wasn't created with [member new_from], this will be [code]null[/code].
	#[var(get=get_data, no_set)]
	data: PhantomVar<Variant>,
}

#[godot_api]
impl IRefCounted for WasmError {
	fn init(_base: Base<Self::Base>) -> Self {
		// Normally we'd panic on using this, but since we have a property, Godot creates a new one upon init.
		Self {
			error: Some(wasmtime::Error::new(WasmGodotError::new("Anonymous WasmError (avoid using `WasmError.new()`)"))),
			data: PhantomVar::default(),
		}
	}
}

#[godot_api]
impl WasmError {
	pub fn new_from_error(error: wasmtime::Error) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(error),
			data: PhantomVar::default(),
		});
	}

	pub fn new_from_any_error(error: anyhow::Error) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(wasmtime::Error::new(WasmAnyError::new(error))),
			data: PhantomVar::default(),
		});
	}

	/// Create a new WasmError holding a godot value. [br]
	#[func]
	pub fn new_from(data: Variant) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(wasmtime::Error::new(WasmGodotError::new(&data))),
			data: PhantomVar::default(),
		});
	}

	/// [WasmError] can only be used once, it must be discarded once passed into wasmtime-gd.
	/// You may use [member is_taken] to check if this [WasmError] is still valid.
	#[func]
	fn is_taken(&self) -> bool {
		return self.error.is_none();
	}

	#[func]
	fn is_throw_exception(&self) -> bool {
		return self.error.as_ref().is_some_and(|e| e.downcast_ref::<ThrownException>().is_some());
	}

	/// The value which was given to [member new_from]. [br]
	/// If the error wasn't created with [member new_from], this will be [code]null[/code].
	#[func]
	fn get_data(&self) -> Variant {
		if let Some(Some(error)) = self.error.as_ref().map(|error| error.downcast_ref::<WasmGodotError>()) {
			return error.data.get().to_variant();
		}
		return Variant::nil();
	}

	#[func]
	pub fn as_string(&self) -> String {
		if let Some(error) = self.error.as_ref() {
			let prefix;
			if let Some(_) = error.downcast_ref::<WasmGodotError>() {
				prefix = "Godot";
			} else if let Some(_) = error.downcast_ref::<WasmAnyError>() {
				prefix = "wasmtime-gd";
			} else if let Some(_) = error.downcast_ref::<ThrownException>() {
				prefix = "WASM Exn";
			} else if let Some(_) = error.downcast_ref::<wasmtime::Trap>() {
				prefix = "WASM Trap";
			} else {
				prefix = "Something";
			}

			let msg = error
				.chain()
				.map(|e| e.to_string())
				.collect::<Vec<_>>()
				.join("\n");

			if INCLUDE_RUST_BACKTRACE.load(std::sync::atomic::Ordering::Relaxed) {
				let rust_backtrace = error.backtrace().to_string()
					.lines()
					.filter(|line| line.contains("wasmtime_gd"))
					.collect::<Vec<&str>>()
					.join("\n");
				return format!("{} returned an error:\n{}\nRust Backtrace:\n{}", prefix, msg, rust_backtrace);
			} else {
				return format!("{} returned an error:\n{}", prefix, msg);
			}
		}
		return "Attempt to print WasmError which has already been taken.".to_string();
	}

	/// Prints/logs the [WasmError] as an error.
	#[func]
	pub fn print(&self) {
		GDScriptStuff::print_error(&self.as_string(), None);
	}

	/// Whether or not to include the rust backtrace when [member print] is called. [br]
	/// Usually you'd have this disabled, unless you are debugging an issue with this gdextension.
	#[func]
	fn set_include_rust_backtrace(enabled: bool) {
		INCLUDE_RUST_BACKTRACE.store(enabled, std::sync::atomic::Ordering::Relaxed);
	}
}
