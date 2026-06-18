use godot::prelude::*;

use crate::{store_same_as::ContextStoreSameAs, to_from_variant::ToFromVariant, utils::GdAsContext, utils_errors::*};
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
    context: DynGd<RefCounted, dyn GdAsContext>,
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
	pub fn new_from(memory: wasmtime::Memory, context: DynGd<RefCounted, dyn GdAsContext>) -> Gd<Self> {
		return Gd::from_object(Self {
			memory,
			context,
		})
	}

	#[func]
	fn new_memory(&self, mut context: DynGd<RefCounted, dyn GdAsContext>, minimum: i64, #[opt(default=-1)] maximum: i64, #[opt(default=false)] is_64: bool) -> Option<Gd<WasmMemory>> {
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
		let memory = wasmtime::Memory::new(&mut context.dyn_bind_mut().as_context_mut(), memory_type)
			.or_print_error("Failed to create memory")?;
		return Some(WasmMemory::new_from(
			memory,
			context
		));
	}

	#[func]
	fn get_memory_type(&self) -> Variant {
		return self.memory.ty(&self.context.dyn_bind().as_context()).to_variant();
	}

	#[func]
	fn size(&self) -> i64 {
		return self.memory.size(&self.context.dyn_bind().as_context()) as i64;
	}

	#[func]
	fn data_size(&self) -> i64 {
		return self.memory.data_size(&self.context.dyn_bind().as_context()) as i64;
	}

	#[func]
	fn page_size(&self) -> i64 {
		return self.memory.page_size(&self.context.dyn_bind().as_context()) as i64;
	}

	#[func]
	fn minimum(&self) -> i64 {
		let ty = self.memory.ty(&self.context.dyn_bind().as_context());
		return ty.minimum() as i64;
	}

	#[func]
	fn maximum(&self) -> i64 {
		let ty = self.memory.ty(&self.context.dyn_bind().as_context());
		return ty.maximum().map_or(i64::MAX, |v| v as i64);
	}

	#[func]
	fn is_64(&self) -> bool {
		let ty = self.memory.ty(&self.context.dyn_bind().as_context());
		return ty.is_64();
	}

	#[func]
	fn is_shared(&self) -> bool {
		let ty = self.memory.ty(&self.context.dyn_bind().as_context());
		return ty.is_shared();
	}

	/// Grows this WebAssembly memory by [param delta] **pages**.
	#[func]
	fn grow(&mut self, delta: i64) -> MyGodotResult<bool> {
		let delta = IntoMyGodotResult::or_godot_error(delta.try_into(), &format!("param delta is out of bounds of u64 (between 0 - {})", u64::MAX), false).without_err()?;
		self.memory.grow(&mut self.context.dyn_bind_mut().as_context_mut(), delta)
			.or_godot_error("Failed to grow memory", false)?;
		return Ok(true);
	}

	fn _write(&mut self, offset: i64, bytes: &[u8]) -> MyGodotResult<bool> {
		let offset = IntoMyGodotResult::or_godot_error(offset.try_into(), &format!("param offset is out of bounds of usize (between 0 - {})", usize::MAX), false).without_err()?;
		self.memory.write(&mut self.context.dyn_bind_mut().as_context_mut(), offset, bytes)
			.or_godot_error("Failed to write memory", false)?;
		return Ok(true);
	}

	#[func]
	fn write(&mut self, offset: i64, bytes: PackedByteArray) -> MyGodotResult<bool> {
		return self._write(offset, bytes.as_slice());
	}

	#[func]
	fn write_i32(&mut self, offset: i64, value: i32) -> MyGodotResult<bool> {
		return self._write(offset, &value.to_le_bytes());
	}

	fn _read(&mut self, offset: i64, bytes: &mut [u8]) -> MyGodotResult<()> {
		self.memory.read(&mut self.context.dyn_bind_mut().as_context_mut(), offset as usize, bytes)
			.or_godot_error("Failed to read memory", ())?;
		return Ok(());
	}
	
	/// Returns array with exactly [param length] bytes, or empty if an error occurred.
	#[func]
	fn read(&mut self, offset: i64, length: i64) -> MyGodotResult<PackedByteArray> {
		let mut bytes = PackedByteArray::new();
		let length = IntoMyGodotResult::or_godot_error(length.try_into(), &format!("param length is out of bounds of usize (between 0 - {})", usize::MAX), PackedByteArray::new()).without_err()?;
		bytes.resize(length);
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(bytes.clone()))?;
		return Ok(bytes);
	}

	#[func]
	fn read_i32(&mut self, offset: i64) -> MyGodotResult<i32> {
		let mut bytes = vec![0; size_of::<i32>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(i32::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

    #[func]
    fn same_as(&mut self, other: Gd<WasmMemory>) -> bool {
        return self.context.dyn_bind().as_context().same_store_as(&other.bind().context.dyn_bind().as_context()) && self.memory.debug_index_in_store() == other.bind().memory.debug_index_in_store();
    }
}
