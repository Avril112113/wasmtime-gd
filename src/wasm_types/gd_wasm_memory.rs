use godot::prelude::*;

use crate::{gd_wasm_store::WasmStore, to_from_variant::ToFromVariant, utils_errors::*};
use super::WasmAsExtern;

/// A Wasmtime Extern::Memory
/// 
/// Note: A simple `==` between [WasmMemory] is not enough, use [method same_as]
/// 
/// WARN: [WasmMemory] doesn't support 64-bit memory very well, as GDScript only supports I64 and not U64.
/// 
/// Note that, by default, a WebAssembly memory's page size is 64KiB (aka
/// 65536 or 2<sup>16</sup>). The [custom-page-sizes proposal] allows Wasm
/// memories to opt into a page size of one byte (and this may be further
/// relaxed to any power of two in a future extension).
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmMemory {
	pub memory: wasmtime::Memory,
	store: Gd<WasmStore>,
}

#[godot_dyn]
impl WasmAsExtern for WasmMemory {
	fn as_extern(&self) -> wasmtime::Extern {
		return wasmtime::Extern::Memory(self.memory);
	}
}

#[godot_api]
impl IRefCounted for WasmMemory {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmMemory.new() is invalid!");
	}
}

#[godot_api]
impl WasmMemory {
	pub fn new_from(memory: wasmtime::Memory, store: Gd<WasmStore>) -> Gd<Self> {
		return Gd::from_object(WasmMemory {
			memory,
			store,
		})
	}

	#[func]
	fn new_memory(&self, mut store: Gd<WasmStore>, minimum: i64, #[opt(default=-1)] maximum: i64, #[opt(default=false)] is_64: bool) -> Option<Gd<WasmMemory>> {
		let mut memory_builder = wasmtime::MemoryTypeBuilder::new();
		
		let minimum = minimum.try_into().or_print_error(&format!("param minimum is out of bounds of u64 (between 0 - {})", u64::MAX))?;
		memory_builder.min(minimum);
		
		if maximum >= 0 {
			let maximum = maximum.try_into().or_print_error(&format!("param maximum is out of bounds of u64 (between 0 - {})", u64::MAX))?;
			memory_builder.max(Some(maximum));
		}
		
		memory_builder.memory64(is_64);

		let memory_type = memory_builder.build()
			.or_print_error("Failed to create memory")?;
		let memory = wasmtime::Memory::new(&mut store.bind_mut().store, memory_type)
			.or_print_error("Failed to create memory")?;
		return Some(WasmMemory::new_from(
			memory,
			store
		));
	}

	#[func]
	fn get_memory_type(&self) -> Variant {
		return self.memory.ty(&self.store.bind().store).to_variant();
	}

	#[func]
	fn size(&self) -> i64 {
		return self.memory.size(&self.store.bind().store) as i64;
	}

	#[func]
	fn data_size(&self) -> i64 {
		return self.memory.data_size(&self.store.bind().store) as i64;
	}

	#[func]
	fn page_size(&self) -> i64 {
		return self.memory.page_size(&self.store.bind().store) as i64;
	}

	#[func]
	fn minimum(&self) -> i64 {
		let ty = self.memory.ty(&self.store.bind().store);
		return ty.minimum() as i64;
	}

	#[func]
	fn maximum(&self) -> i64 {
		let ty = self.memory.ty(&self.store.bind().store);
		return ty.maximum().map_or(i64::MAX, |v| v as i64);
	}

	#[func]
	fn is_64(&self) -> bool {
		let ty = self.memory.ty(&self.store.bind().store);
		return ty.is_64();
	}

	#[func]
	fn is_shared(&self) -> bool {
		let ty = self.memory.ty(&self.store.bind().store);
		return ty.is_shared();
	}

	/// Grows this WebAssembly memory by [param delta] **pages**.
	#[func]
	fn grow(&mut self, delta: i64) -> MyGodotResult<bool> {
		let delta = IntoMyGodotResult::or_godot_error(delta.try_into(), &format!("param delta is out of bounds of u64 (between 0 - {})", u64::MAX), false).without_err()?;
		self.memory.grow(&mut self.store.bind_mut().store, delta)
			.or_godot_error("Failed to grow memory", false)?;
		return Ok(true);
	}

	#[func]
	fn write(&mut self, offset: i64, bytes: PackedByteArray) -> MyGodotResult<bool> {
		let offset = IntoMyGodotResult::or_godot_error(offset.try_into(), &format!("param offset is out of bounds of usize (between 0 - {})", usize::MAX), false).without_err()?;
		self.memory.write(&mut self.store.bind_mut().store, offset, bytes.as_slice())
			.or_godot_error("Failed to write memory", false)?;
		return Ok(true);
	}
	
	/// Returns array with exactly [param length] bytes, or empty if an error occurred.
	#[func]
	fn read(&mut self, offset: i64, length: i64) -> MyGodotResult<PackedByteArray> {
		let mut bytes = PackedByteArray::new();
		let length = IntoMyGodotResult::or_godot_error(length.try_into(), &format!("param length is out of bounds of usize (between 0 - {})", usize::MAX), PackedByteArray::new()).without_err()?;
		bytes.resize(length);
		self.memory.read(&mut self.store.bind_mut().store, offset as usize, bytes.as_mut_slice())
			.or_godot_error("Failed to read memory", PackedByteArray::new())?;
		return Ok(bytes);
	}

    #[func]
    fn same_as(&mut self, other: Gd<WasmMemory>) -> bool {
        return self.store.bind().same_as_(&other.bind().store.bind()) && self.memory.debug_index_in_store() == other.bind().memory.debug_index_in_store();
    }
}
