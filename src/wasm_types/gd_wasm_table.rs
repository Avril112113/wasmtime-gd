use godot::prelude::*;

use crate::{store_same_as::ContextStoreSameAs, to_from_variant::ToFromVariant, utils::GdAsContext, utils_errors::{IntoMyGodotResult, MyGodotResult}, wasm_types::{ValFromVariantByValType, ValToVariant}};
use super::WasmAsExtern;


// #[derive(Clone)]
// struct SendCallable(Callable);
//
// unsafe impl Send for SendCallable {}
// unsafe impl Sync for SendCallable {}


/// A Wasmtime Extern::Table
/// 
/// Note: A simple `==` between [WasmTable] is not enough.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmTable {
	pub table: wasmtime::Table,
	context: DynGd<RefCounted, dyn GdAsContext>,
}

#[godot_dyn]
impl WasmAsExtern for WasmTable {
	fn as_extern(&self) -> wasmtime::Extern {
		return wasmtime::Extern::Table(self.table);
	}
}

#[godot_api]
impl IRefCounted for WasmTable {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmTable.new() is invalid!");
	}
}

#[godot_api]
impl WasmTable {
	pub fn new_from(table: wasmtime::Table, context: DynGd<RefCounted, dyn GdAsContext>) -> Gd<Self> {
		// Callee may expect `context` to not be bound to during this call.
		return Gd::from_object(WasmTable {
			table,
			context,
		})
	}

	/// Returns the underlying type of this table, including its element type as well as the maximum/minimum lower bounds.
	#[func]
	pub fn get_table_type(&self) -> Variant {
		return self.table.ty(&mut self.context.dyn_bind().as_context()).to_variant();
	}

	/// Returns the element value type of this table.
	#[func]
	pub fn get_element_type(&self) -> Variant {
		return self.table.ty(&mut self.context.dyn_bind().as_context()).element().to_variant();
	}

	/// Returns minimum number of elements this table must have.
	#[func]
	fn minimum(&self) -> i64 {
		let ty = self.table.ty(&self.context.dyn_bind().as_context());
		return ty.minimum() as i64;
	}

	/// Returns the optionally-specified maximum number of elements this table can have. [br]
	/// If there is no limit, returns i64::MAX
	#[func]
	fn maximum(&self) -> i64 {
		let ty = self.table.ty(&self.context.dyn_bind().as_context());
		return ty.maximum().map_or(i64::MAX, |v| v as i64);
	}

	/// Returns whether this is a 64-bit table or not.
	#[func]
	fn is_64(&self) -> bool {
		let ty = self.table.ty(&self.context.dyn_bind().as_context());
		return ty.is_64();
	}

	/// Returns the current size of this table.
	#[func]
	pub fn size(&self) -> i64 {
		return self.table.size(&mut self.context.dyn_bind().as_context()) as i64;
	}

	/// Returns the table element value at [param]index[/param]. [br]
	/// Returns [null] if [param]index[/param] is out of bounds.
	#[func]
	pub fn get(&mut self, index: i64) -> MyGodotResult<Variant> {
		if index < 0 {
			return Ok(Variant::nil());
		}
        let r#ref = self.table.get(&mut self.context.dyn_bind_mut().as_context_mut(), index as u64)
            .or_godot_error("Failed to set table:", Variant::nil())?;
		return Ok(wasmtime::Val::from(r#ref).to_variant(self.context.clone()));
	}

	/// Writes the [param]value[/param] provided into [param]index[/param] within this table.
	#[func]
	pub fn set(&mut self, index: i64, value: Variant) -> MyGodotResult<bool> {
		if index < 0 {
			return Ok(true);
		}
		let table_type = self.table.ty(&self.context.dyn_bind().as_context());
        let val = table_type.element().val_from(value, &mut self.context.dyn_bind_mut().as_context_mut())
            .or_godot_error("Failed to convert Variant:", false)?;
        self.table.set(&mut self.context.dyn_bind_mut().as_context_mut(), index as u64, val.ref_().or_godot_error("expected ref type", false)?)
            .or_godot_error("Failed to set table:", false)?;
		return Ok(true);
	}

	/// Fill [code]table[dst..(dst + len)][/code] with the given value.
	#[func]
	pub fn fill(&mut self, dst: i64, init: Variant, len: i64) -> MyGodotResult<bool> {
		if dst < 0 || len < 0 {
			return Ok(true);
		}
		let table_type = self.table.ty(&self.context.dyn_bind().as_context());
        let val = table_type.element().val_from(init, &mut self.context.dyn_bind_mut().as_context_mut())
            .or_godot_error("Failed to convert Variant:", false)?;
        self.table.fill(&mut self.context.dyn_bind_mut().as_context_mut(), dst as u64, val.ref_().or_godot_error("expected ref type", false)?, len as u64)
            .or_godot_error("Failed to set table:", false)?;
		return Ok(true);
	}

	/// Returns an error if the table cannot be grown by [param]delta[/param], for example if it would cause the table to exceed its maximum size.
	/// Also returns an error if [param]init[/param] is not of the right type or if [param]init[/param] does not belong to store.
	#[func]
	pub fn grow(&mut self, delta: i64, init: Variant) -> MyGodotResult<bool> {
		if delta < 0 {
			return Ok(true);
		}
		let table_type = self.table.ty(&self.context.dyn_bind().as_context());
        let val = table_type.element().val_from(init, &mut self.context.dyn_bind_mut().as_context_mut())
            .or_godot_error("Failed to convert Variant:", false)?;
        self.table.grow(&mut self.context.dyn_bind_mut().as_context_mut(), delta as u64, val.ref_().or_godot_error("expected ref type", false)?)
            .or_godot_error("Failed to set table:", false)?;
		return Ok(true);
	}

	/// Check if 2 [WasmTable]s are actually the same table.
	/// Note that, many separate [WasmTable] objects can refer to the same table!
    #[func]
    fn same_as(&mut self, other: Gd<WasmTable>) -> bool {
        return self.context.dyn_bind().as_context().same_store_as(&other.bind().context.dyn_bind().as_context()) && self.table.debug_index_in_store() == other.bind().table.debug_index_in_store();
    }
}
