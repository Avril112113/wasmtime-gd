use std::sync::atomic::AtomicBool;

use godot::{meta::AsArg, prelude::*};
use wasmtime::ThrownException;

use crate::{gd_script_stuff::{GDScriptStuff, ToPrintSourceOption}, get_last_print_source, thread_safe_variant::ThreadVariant};


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
	created_source: Option<(String, String, u32)>,

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
			created_source: GDScriptStuff::get_last_frame_info(),
			data: PhantomVar::default(),
		}
	}
}

#[godot_api]
impl WasmError {
	pub fn new_from_error(error: wasmtime::Error) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(error),
			created_source: GDScriptStuff::get_last_frame_info(),
			data: PhantomVar::default(),
		});
	}

	pub fn new_from_any_error(error: anyhow::Error) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(wasmtime::Error::new(WasmAnyError::new(error))),
			created_source: GDScriptStuff::get_last_frame_info(),
			data: PhantomVar::default(),
		});
	}

	/// Create a new WasmError holding a godot value. [br]
	#[func]
	pub fn new_from(data: Variant) -> Gd<Self> {
		return Gd::from_object(Self {
			error: Some(wasmtime::Error::new(WasmGodotError::new(&data))),
			created_source: GDScriptStuff::get_last_frame_info(),
			data: PhantomVar::default(),
		});
	}

	/// [WasmError] can only be used once, it must be discarded once passed into wasmtime-gd.
	/// You may use [member is_taken] to check if this [WasmError] is still valid.
	#[func]
	fn is_taken(&self) -> bool {
		return self.error.is_none();
	}

	/// Wether or not this error is a thrown WASM exception.
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

	/// The error as a string, as seen by [method print]
	#[func]
	pub fn as_string(&self) -> String {
		if let Some(error) = self.error.as_ref() {
			let prefix =
				if error.downcast_ref::<WasmGodotError>().is_some() {
					"Godot"
				} else if error.downcast_ref::<WasmAnyError>().is_some() {
					"wasmtime-gd"
				} else if error.downcast_ref::<ThrownException>().is_some() {
					"WASM Exn"
				} else if error.downcast_ref::<wasmtime::Trap>().is_some() {
					"WASM Trap"
				} else {
					"Something"
				};

			let msg = error
				.chain()
				.map(|e| e.to_string())
				.collect::<Vec<_>>()
				.join("\n");

			if INCLUDE_RUST_BACKTRACE.load(std::sync::atomic::Ordering::Relaxed) {
				let rust_backtrace = error.backtrace().to_string();
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
		if let Some(created_source) = &self.created_source {
			if let Some(print_source) = get_last_print_source!() {
				GDScriptStuff::print_error(&format!("{}:{} - {}", created_source.1, created_source.2, self.as_string()), None, Some(print_source));
			} else {
				GDScriptStuff::print_error(&self.as_string(), None, self.created_source.to_print_source());
			}
		} else {
			GDScriptStuff::print_error(&self.as_string(), None, get_last_print_source!());
		}
	}

	/// Whether or not to include the rust backtrace when [member print] is called. [br]
	/// Usually you'd have this disabled, unless you are debugging an issue with this gdextension.
	#[func]
	fn set_include_rust_backtrace(enabled: bool) {
		INCLUDE_RUST_BACKTRACE.store(enabled, std::sync::atomic::Ordering::Relaxed);
	}
}
