use godot::prelude::*;

use crate::{gd_script_stuff::GDScriptStuff, gd_wasm_caller::WasmCaller, gd_wasm_error::WasmError, to_from_variant::ToFromVariant, utils::GdAsContext, utils_errors::*, wasm_types::*};
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
	context: DynGd<RefCounted, dyn GdAsContext>,
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
	pub fn new_from(func: wasmtime::Func, context: DynGd<RefCounted, dyn GdAsContext>) -> Gd<Self> {
		// Callee may expect `context` to not be binded to during this call.
		return Gd::from_object(WasmFunc {
			func,
			context,
		})
	}

	#[func]
	fn from_callable(mut context: DynGd<RefCounted, dyn GdAsContext>, param_types: Array<Variant>, result_types: Array<Variant>, callable: Callable) -> MyGodotResult<Option<Gd<Self>>> {
		let gd_context: DynGd<RefCounted, _> = context.clone();
		
		let callable = fragile::Fragile::new(callable);
		// let callable = SendCallable(callable);

  		let engine = &mut context.dyn_bind_mut().as_context_mut().engine().clone();
		
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
			&mut context.dyn_bind_mut().as_context_mut(), func_type.clone(),
			move |caller, params, results| {
				let mut varags: Vec<Variant> = params.iter().map(|v| v.into_variant()).collect();
				
				let gd_caller;
				unsafe {
					gd_caller = WasmCaller::new_from(std::mem::transmute(caller));
				}
				let _guard = scopeguard::guard((), |_| {
					gd_caller.clone().bind_mut().invalidate();
				});
				varags.insert(0, gd_caller.to_variant());
				
				// let result = callable.clone().0.call(&varags);
				let result = callable.get().call(&varags);

				if let Ok(mut err) = result.try_to::<Gd<WasmError>>() {
					let error = err.bind_mut().error.take()
						.ok_or_else(|| wasmtime::Error::msg("WasmError's error was already taken! Do not reuse WasmError!"))?;
					return Err(error);
				}
				
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

		return Ok(Some(Self::new_from(func, gd_context)));
	}

	#[func]
	fn get_func_type(&mut self) -> Variant {
		let dyn_context = self.context.dyn_bind();
		let context = &mut dyn_context.as_context();
		return self.func.ty(context).to_variant();
	}

	#[func]
	fn get_param_types(&mut self) -> Array<Variant> {
		let dyn_context = self.context.dyn_bind();
		let context = &mut dyn_context.as_context();
		return Array::from_iter(self.func.ty(context).params().map(|ty| ty.to_variant()));
	}

	#[func]
	fn get_result_types(&mut self) -> Array<Variant> {
		let dyn_context = self.context.dyn_bind();
		let context = &mut dyn_context.as_context();
		return Array::from_iter(self.func.ty(context).results().map(|ty| ty.to_variant()));
	}

	fn call_wasm_internal(&mut self, args: Array<Variant>) -> Result<wasmtime::Result<Vec<wasmtime::Val>>, MyGodotError<Variant>> {
		let mut dyn_context_mut = self.context.dyn_bind_mut();
		let mut context_mut = &mut dyn_context_mut.as_context_mut();
		
		let func_type = self.func.ty(&mut context_mut);
		let param_types = func_type.params();

		if args.len() != param_types.len() {
			return Err(()).or_godot_error(&format!("Incorrect number or args, expected {} but got {}", param_types.len(), args.len()), Variant::nil())?;
		}

		let params = param_types.enumerate().map(|(i, ty)| -> Result<wasmtime::Val, MyGodotError<Variant>> {
			return ty.val_from(args.at(i)).or_godot_error(&format!("Invalid arg type arg #{}, expected {}", i, ty), Variant::nil());
		}).collect::<Result<Vec<wasmtime::Val>, MyGodotError<Variant>>>()?;
		let mut results = self.func.ty(&mut context_mut).results().map(|ty| {
			if let Some(val) = ty.default_value() {
				return val;
			}
			return match ty {
				wasmtime::ValType::Ref(r) => wasmtime::Val::null_ref(r.heap_type()),
				_ => unreachable!(),
			};
		}).collect::<Vec<wasmtime::Val>>();

		return Ok(self.func.call(&mut context_mut, params.as_slice(), results.as_mut_slice()).map(|()| results));
	}

	// https://github.com/godot-rust/gdext/issues/1472
	/// Returns an array of values, or `nil` if the function has no returns. [br]
	/// Otherwise returns [WasmError] in the case of an error (Trap or Exception).
	#[func]
	fn call_wasm(&mut self, args: Array<Variant>) -> MyGodotResult<Variant> {
		return match self.call_wasm_internal(args)? {
			Ok(results) => match results.len() {
				0 => Ok(Variant::nil()),
				_ => Ok(Array::from_iter(results.iter().map(|val| val.into_variant())).to_variant())
			},
			Err(error) => Ok(WasmError::new_from_error(error).to_variant()),
		};
	}

	// https://github.com/godot-rust/gdext/issues/1472
	/// Returns an array of values, or `nil` if the function has no returns. [br]
	/// Otherwise returns [WasmError] in the case of an error (Trap or Exception). [br]
	/// 
	/// Same as [member call_wasm] except in the case of an error, it always prints it. 
	#[func]
	fn call_wasm_and_print_err(&mut self, args: Array<Variant>) -> MyGodotResult<Variant> {
		return match self.call_wasm_internal(args)? {
			Ok(results) => match results.len() {
				0 => Ok(Variant::nil()),
				_ => Ok(Array::from_iter(results.iter().map(|val| val.into_variant())).to_variant())
			},
			Err(error) => {
				GDScriptStuff::print_error(&format!("WASM returned an error: {}", error), None);
				Ok(WasmError::new_from_error(error).to_variant())
			},
		};
	}
}
