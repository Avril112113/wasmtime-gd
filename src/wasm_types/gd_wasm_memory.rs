use godot::prelude::*;

use crate::{active_context::WasmContext, store_same_as::ContextStoreSameAs, to_from_variant::ToFromVariant, utils_errors::*};
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
    context: WasmContext,
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
	pub fn new_from(memory: wasmtime::Memory, context: WasmContext) -> Gd<Self> {
		return Gd::from_object(Self {
			memory,
			context,
		})
	}

	/// Creates a new [WasmMemory]
	#[func]
	fn new_memory(&self, context: WasmContext, minimum: i64, #[opt(default=-1)] maximum: i64, #[opt(default=false)] is_64: bool) -> Option<Gd<WasmMemory>> {
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
		let memory = wasmtime::Memory::new(self.context.as_context_mut(), memory_type)
			.or_print_error("Failed to create memory")?;
		return Some(WasmMemory::new_from(
			memory,
			context
		));
	}

	/// Returns the memory type. The contents may change in the future, only pass this value back to wasmtime-gd.
	#[func]
	fn get_memory_type(&self) -> Variant {
		return self.memory.ty(self.context.as_context()).to_variant();
	}

	/// Returns the size, in units of pages, of this Wasm memory.
	#[func]
	fn size(&self) -> i64 {
		return self.memory.size(self.context.as_context()) as i64;
	}

	/// Returns the byte length of this memory.
	#[func]
	fn data_size(&self) -> i64 {
		return self.memory.data_size(self.context.as_context()) as i64;
	}

	/// Returns the size of a page, in bytes, for this memory.
	#[func]
	fn page_size(&self) -> i64 {
		return self.memory.page_size(self.context.as_context()) as i64;
	}

	/// Returns minimum number of WebAssembly pages this memory must have.
	#[func]
	fn minimum(&self) -> i64 {
		let ty = self.memory.ty(self.context.as_context());
		return ty.minimum() as i64;
	}

	/// Returns the optionally-specified maximum number of pages this memory can have. [br]
	/// If there is no limit, returns i64::MAX
	#[func]
	fn maximum(&self) -> i64 {
		let ty = self.memory.ty(self.context.as_context());
		return ty.maximum().map_or(i64::MAX, |v| v as i64);
	}

	/// Returns whether this is a 64-bit memory or not.
	#[func]
	fn is_64(&self) -> bool {
		let ty = self.memory.ty(self.context.as_context());
		return ty.is_64();
	}

	/// Returns whether this is a shared memory or not.
	#[func]
	fn is_shared(&self) -> bool {
		let ty = self.memory.ty(self.context.as_context());
		return ty.is_shared();
	}

	/// Grows this WebAssembly memory by [param delta] **pages**.
	#[func]
	fn grow(&mut self, delta: i64) -> MyGodotResult<bool> {
		let delta = IntoMyGodotResult::or_godot_error(delta.try_into(), &format!("param delta is out of bounds of u64 (between 0 - {})", u64::MAX), false).without_err()?;
		self.memory.grow(self.context.as_context_mut(), delta)
			.or_godot_error("Failed to grow memory", false)?;
		return Ok(true);
	}

	fn _write(&mut self, offset: i64, bytes: &[u8], align: i64) -> MyGodotResult<i64> {
		let offset = IntoMyGodotResult::or_godot_error(offset.try_into(), &format!("param offset is out of bounds of usize (between 0 - {})", usize::MAX), 0).without_err()?;
		if align <= 0 {
			return Err(MyGodotError::from("Align must be greater than 0".into(), 0));
		}
		self.memory.write(self.context.as_context_mut(), offset, bytes)
			.or_godot_error("Failed to write memory", 0)?;
		return Ok((bytes.len() as i64).next_multiple_of(align));
	}

	/// Safely writes [param bytes] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided.
	/// [code]0[/code] in the case of error, otherwise [code]len(bytes)[/code]
	#[func]
	fn write(&mut self, offset: i64, bytes: PackedByteArray, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, bytes.as_slice(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 1 byte
	#[func]
	fn write_i8(&mut self, offset: i64, value: i8, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 1 byte
	#[func]
	fn write_u8(&mut self, offset: i64, value: u8, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 2 bytes
	#[func]
	fn write_i16(&mut self, offset: i64, value: i16, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 2 bytes
	#[func]
	fn write_u16(&mut self, offset: i64, value: u16, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 4 bytes
	#[func]
	fn write_i32(&mut self, offset: i64, value: i32, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 4 bytes
	#[func]
	fn write_u32(&mut self, offset: i64, value: u32, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// Size: 8 bytes
	#[func]
	fn write_i64(&mut self, offset: i64, value: i64, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		return self._write(offset, &value.to_le_bytes(), align);
	}

	/// Safely writes [param value] to this memory at the given offset. [br]
	/// Returns the amount of bytes written, or the next multiple of [param align] if provided. [br]
	/// NOTE: Godot numbers can't represent a u64, max value is i64. [br]
	/// Size: 8 bytes
	#[func]
	fn write_u64(&mut self, offset: i64, value: i64, #[opt(default = 1)] align: i64) -> MyGodotResult<i64> {
		let value: u64 = IntoMyGodotResult::or_godot_error(value.try_into(), &format!("param value is out of bounds of u64 (between 0 - {})", u64::MAX), 0).without_err()?;
		return self._write(offset, &value.to_le_bytes(), align);
	}

	fn _read(&mut self, offset: i64, bytes: &mut [u8]) -> MyGodotResult<()> {
		let offset = IntoMyGodotResult::or_godot_error(offset.try_into(), &format!("param offset is out of bounds of usize (between 0 - {})", usize::MAX), ()).without_err()?;
		self.memory.read(self.context.as_context_mut(), offset, bytes)
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

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 1 byte
	#[func]
	fn read_i8(&mut self, offset: i64) -> MyGodotResult<i8> {
		let mut bytes = vec![0; size_of::<i8>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(i8::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 1 byte
	#[func]
	fn read_u8(&mut self, offset: i64) -> MyGodotResult<u8> {
		let mut bytes = vec![0; size_of::<u8>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(u8::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 2 bytes
	#[func]
	fn read_i16(&mut self, offset: i64) -> MyGodotResult<i16> {
		let mut bytes = vec![0; size_of::<i16>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(i16::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 2 bytes
	#[func]
	fn read_u16(&mut self, offset: i64) -> MyGodotResult<u16> {
		let mut bytes = vec![0; size_of::<u16>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(u16::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 4 bytes
	#[func]
	fn read_i32(&mut self, offset: i64) -> MyGodotResult<i32> {
		let mut bytes = vec![0; size_of::<i32>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(i32::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 4 bytes
	#[func]
	fn read_u32(&mut self, offset: i64) -> MyGodotResult<u32> {
		let mut bytes = vec![0; size_of::<u32>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(u32::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// Size: 8 bytes
	#[func]
	fn read_i64(&mut self, offset: i64) -> MyGodotResult<i64> {
		let mut bytes = vec![0; size_of::<i64>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return Ok(i64::from_le_bytes(bytes.as_slice().try_into().unwrap()));
	}

	/// Returns value at [param offset], or [code]0[/code] if an error occurred. [br]
	/// NOTE: Godot numbers can't represent a u64, max value is i64. [br]
	/// Size: 8 bytes
	#[func]
	fn read_u64(&mut self, offset: i64) -> MyGodotResult<i64> {
		let mut bytes = vec![0; size_of::<u64>()];
		self._read(offset, bytes.as_mut_slice()).map_err(|err| err.with_value(0))?;
		return i64::try_from(u64::from_le_bytes(bytes.as_slice().try_into().unwrap()))
			.or_godot_error("u64 value was larger than a i64's positive section, which godot can't represent.", 0);
	}

	/// Check if 2 [WasmMemory]s are actually the same memory.
	/// Note that, many separate [WasmMemory] objects can refer to the same memory!
    #[func]
    fn same_as(&mut self, other: Gd<WasmMemory>) -> bool {
        let other = other.bind();
		let context_self = self.context.as_context();
		let context_other = other.context.as_context();
        return context_self.same_store_as(&context_other) && self.memory.debug_index_in_store() == other.memory.debug_index_in_store();
    }
}
