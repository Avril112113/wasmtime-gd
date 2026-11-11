use godot::{classes::{FileAccess, file_access::ModeFlags}, prelude::*};

use crate::{gd_wasm_engine::WasmEngine, to_from_variant::ToFromVariant, utils_errors::*};

/// A Wasmtime Linker, to link wasm modules/instances together and provide imports from the host.
/// 
/// **DO NOT USE `WasmModule.new()` it will return null.**
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmModule {
	pub module: wasmtime::Module,
}

#[godot_api]
impl IRefCounted for WasmModule {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmModule.new() is invalid!");
	}
}

#[godot_api]
impl WasmModule {
	pub fn from_module(module: wasmtime::Module) -> Gd<Self> {
		return Gd::from_object(Self {
			module,
		});
	}

	/// Create new Wasmtime module.
	/// 
	/// [param bytes] can be either a WASM binary or WAT text.
	/// 
	/// Use [member new_from_string] if you want to use a [String] for WAT.
	/// 
	/// May return `null` in case of error, which will be logged.
	#[func]
	fn new_from(engine: Gd<WasmEngine>, bytes: PackedByteArray) -> Option<Gd<Self>> {
		let module = wasmtime::Module::new(&engine.bind().engine, bytes.as_slice())
			.or_print_error("Failed to create Module")?;
		
		return Some(Self::from_module(module));
	}

	/// Create new Wasmtime module from a [String], which should contain WebAssembly Text .wat
	/// 
	/// May return `null` in case of error, which will be logged.
	#[func]
	fn new_from_string(engine: Gd<WasmEngine>, wat: GString) -> Option<Gd<Self>> {
		// `wat.to_string().as_bytes()` may not be ideal, as it make a copy.
		let module = wasmtime::Module::new(&engine.bind().engine, wat.to_string().as_bytes())
			.or_print_error("Failed to create Module")?;

		return Some(Self::from_module(module));
	}

	/// Reads a file using [FileAccess] and then passes that to [member new_from]
	/// 
	/// May return `null` in case of error, which will be logged.
	#[func]
	fn new_from_file(engine: Gd<WasmEngine>, path: GString) -> Option<Gd<Self>> {
		let mut file = FileAccess::open(&path, ModeFlags::READ)
			.or_print_error("Failed to open file")?;
		let length = file.get_length().try_into().expect("file.get_length().try_into() failed?");
		let packed_byte_array = file.get_buffer(length);
		file.close();
		drop(file);
		return Self::new_from(engine, packed_byte_array);
	}

	/// Load a previously [member serialize] module. [br]
	/// [img width=16]res://addons/wasmtime-gd/warn_icon.png[/img] [b]UNSAFE, [param bytes] has minimal validation! Whoever can modify [param bytes] could get arbitrary code execution![/b]
	#[func]
	fn deserialize(engine: Gd<WasmEngine>, bytes: PackedByteArray) -> Option<Gd<Self>> {
		// SAFETY: As noted in this functions comment, this is unsafe with un-trusted input. 
		let module = unsafe { wasmtime::Module::deserialize(&engine.bind().engine, bytes.as_slice()) }
			.or_print_error("Failed to deserialize compiled module")?;
		return Some(Self::from_module(module));
	}

	/// Serialize the compiled WASM module, which can later be deserialized. Pre-compiling can be considerably faster (100x or more) [br]
	/// Make sure to read the warning in [member deserialize]
	#[func]
	fn serialize(&self) -> MyGodotResult<PackedByteArray> {
		let bytes = self.module.serialize().or_godot_error_fn("Failed to serialize WasmModule", PackedByteArray::new)?;
		let mut gd_bytes = PackedByteArray::new();
		gd_bytes.resize(bytes.len());
		gd_bytes.as_mut_slice().copy_from_slice(bytes.as_slice());
		return Ok(gd_bytes);
	}

	/// Get the imports this module expects to be provided in the [WasmLinker]
	#[func]
	fn get_imports(&mut self) -> AnyDictionary {
		let mut dict = Dictionary::<GString,Variant>::new();
		for export in self.module.imports() {
			dict.set(export.name(), &export.ty().to_variant());
		}
		return dict.upcast_any_dictionary();
	}

	/// Get the exports this module provides to the host and other modules.
	#[func]
	fn get_exports(&mut self) -> AnyDictionary {
		let mut dict = Dictionary::<GString,Variant>::new();
		for export in self.module.exports() {
			dict.set(export.name(), &export.ty().to_variant());
		}
		return dict.upcast_any_dictionary();
	}
}
