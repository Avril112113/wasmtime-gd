use godot::prelude::*;

use crate::{gd_wasm_store::WasmStore, to_from_variant::ToFromVariant, utils_errors::*, wasm_types::*};
use super::WasmAsExtern;


// #[derive(Clone)]
// struct SendCallable(Callable);
//
// unsafe impl Send for SendCallable {}
// unsafe impl Sync for SendCallable {}


/// A Wasmtime Extern::Func
/// 
/// Note: A simple `==` between [WasmFunc] is not enough.
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmFunc {
	pub func: wasmtime::Func,
	store: Gd<WasmStore>,
}

#[godot_dyn]
impl WasmAsExtern for WasmFunc {
	fn as_extern(&self) -> wasmtime::Extern {
		return wasmtime::Extern::Func(self.func);
	}
}

#[godot_api]
impl IRefCounted for WasmFunc {
	fn init(_base: Base<Self::Base>) -> Self {
		panic!("WasmFunc.new() is invalid!");
	}
}

#[godot_api]
impl WasmFunc {
	pub fn new_from(func: wasmtime::Func, store: Gd<WasmStore>) -> Gd<Self> {
		// Callee may expect `store` to not be binded to during this call.
		return Gd::from_object(WasmFunc {
			func,
			store,
		})
	}

	#[func]
	fn from_callable(mut store: Gd<WasmStore>, param_types: Array<Variant>, result_types: Array<Variant>, callable: Callable) -> MyGodotResult<Option<Gd<Self>>> {
		let gd_store = store.clone();
		
		let callable = fragile::Fragile::new(callable);
		// let callable = SendCallable(callable);

		let mut store_mut = &mut store.bind_mut().store;
  		let engine = store_mut.engine();
		
		let params = param_types.iter_shared()
			.enumerate()
			.map(|(i, v)|
				wasmtime::ValType::from_variant(engine, &v).map_err(|err| ConvertError::new(format!("result type {}: {}", i, err)))
			)
			.collect::<Result<Vec<wasmtime::ValType>, ConvertError>>()
			.or_godot_error("Invalid param types", None)?;
		
		let results = result_types.iter_shared()
			.enumerate()
			.map(|(i, v)|
				wasmtime::ValType::from_variant(engine, &v).map_err(|err| ConvertError::new(format!("result type {}: {}", i, err)))
			)
			.collect::<Result<Vec<wasmtime::ValType>, ConvertError>>()
			.or_godot_error("Invalid result types", None)?;

		let func_type = wasmtime::FuncType::new(
			engine,
			params,
			results
		);

		let func = wasmtime::Func::new(
			&mut store_mut, func_type.clone(),
			move |_caller, params, results| {
				let varags: Vec<Variant> = params.iter().map(|v| v.into_variant()).collect();
				// let result = callable.clone().0.call(&varags);
				let result = callable.get().call(&varags);
				match results.len() {
					0 => {},
					1 => results[0] = func_type.result(0).unwrap().val_from(result).into_trap()?,
					len => {
						let array: Array<Variant> = result.try_to().into_trap()?;
						if len != array.len() {
							return Err(wasmtime::Error::msg(format!("Incorrect return value count, expected {} but got {}", len, array.len())));
						}
						for i in 0..len {
							results[i] = func_type.result(i).unwrap().val_from(array.at(i)).into_trap()?;
						}
					}
				}
				return Ok(());
			}
		);

		return Ok(Some(Self::new_from(func, gd_store)));
	}

	#[func]
	fn get_func_type(&mut self) -> Variant {
		let store = &mut self.store.bind_mut().store;
		return self.func.ty(store).to_variant();
	}

	#[func]
	fn get_param_types(&mut self) -> Array<Variant> {
		let store = &mut self.store.bind_mut().store;
		return Array::from_iter(self.func.ty(store).params().map(|ty| ty.to_variant()));
	}

	#[func]
	fn get_result_types(&mut self) -> Array<Variant> {
		let store = &mut self.store.bind_mut().store;
		return Array::from_iter(self.func.ty(store).results().map(|ty| ty.to_variant()));
	}

	// https://github.com/godot-rust/gdext/issues/1472
	/// Returns an array of values, or `nil` if the function has no returns.
	#[func]
	fn call_wasm(&mut self, args: Array<Variant>) -> MyGodotResult<Variant> {
		let mut store = &mut self.store.bind_mut().store;
		
		let func_type = self.func.ty(&mut store);
		let param_types = func_type.params();

		if args.len() != param_types.len() {
			return Err(()).or_godot_error(&format!("Incorrect number or args, expected {} but got {}", param_types.len(), args.len()), Variant::nil())?;
		}

		let params = param_types.enumerate().map(|(i, ty)| -> Result<wasmtime::Val, MyGodotError<Variant>> {
			return ty.val_from(args.at(i)).or_godot_error(&format!("Invalid arg type arg #{}, expected {}", i, ty), Variant::nil());
		}).collect::<Result<Vec<wasmtime::Val>, MyGodotError<Variant>>>()?;
		let mut results = self.func.ty(&mut store).results().map(|ty| {
			if let Some(val) = ty.default_value() {
				return val;
			}
			return match ty {
				wasmtime::ValType::Ref(r) => wasmtime::Val::null_ref(r.heap_type()),
				_ => unreachable!(),
			};
		}).collect::<Vec<wasmtime::Val>>();

		self.func.call(&mut store, params.as_slice(), results.as_mut_slice())
			.or_godot_error("Call error:", Variant::nil())?;

		return match results.len() {
			0 => Ok(Variant::nil()),
			_ => Ok(Array::from_iter(results.iter().map(|val| val.into_variant())).to_variant())
		};
	}
}
