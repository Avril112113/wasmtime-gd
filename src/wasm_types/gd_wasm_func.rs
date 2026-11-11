
use std::{cell::RefCell, collections::{HashMap, hash_map}, sync::{LazyLock, Mutex}, thread::{self, ThreadId}};

use godot::prelude::*;

use crate::{gd_wasm_caller::WasmCaller, gd_wasm_error::WasmError, to_from_variant::ToFromVariant, utils::GdAsContext, utils_errors::*, wasm_types::*};
use super::WasmAsExtern;


thread_local! {
	pub(crate) static ACTIVE_CALLERS: RefCell<Vec<DynGd<RefCounted, dyn GdAsContext>>> = RefCell::new(Vec::new());
}
static ACTIVE_CALL_THREADS: Mutex<LazyLock<HashMap<InstanceId, ThreadId>>> = Mutex::new(LazyLock::new(|| HashMap::new()));


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
		// Callee may expect `context` to not be bound to during this call.
		return Gd::from_object(WasmFunc {
			func,
			context,
		})
	}

	/// Creates a new [WasmFunc] from a godot [Callable] [br]
	/// If [param fuel_cost] [code]>= 0[/code], this much fuel will be consumed when called, otherwise the default from [property WasmStore.host_call_fuel_use] [br]
	/// Ensure the callable stays valid! See this issue: https://github.com/godotengine/godot/issues/74990
	#[func]
	fn from_callable(mut context: DynGd<RefCounted, dyn GdAsContext>, param_types: Array<Variant>, result_types: Array<Variant>, callable: Callable, #[opt(default=-1)] fuel_cost: i64) -> MyGodotResult<Option<Gd<Self>>> {
		let gd_context: DynGd<RefCounted, _> = context.clone();
		
		let callable = fragile::Fragile::new(callable);

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
			move |mut caller, params, results| {
				let fuel_call_use = if fuel_cost >= 0 { fuel_cost as u64 } else { caller.data().call_fuel_use };
				match caller.get_fuel() {
					Ok(fuel) => {
						caller.set_fuel(fuel - fuel_call_use).unwrap();
					},
					Err(_err) => {},
				};

				// transmute to 'static
				let gd_caller = unsafe { WasmCaller::new_from(std::mem::transmute(caller)) };
				ACTIVE_CALLERS.with_borrow_mut(|callers| { callers.push(gd_caller.clone().into_dyn().upcast()); });
				let _guard = scopeguard::guard((), |_| {
					ACTIVE_CALLERS.with_borrow_mut(|callers| { callers.pop().unwrap() });
					gd_caller.clone().bind_mut().invalidate();
				});
				
				let mut varargs: Vec<Variant> = params.iter().map(|v| v.to_variant(gd_caller.clone().into_dyn().upcast())).collect();
				varargs.insert(0, gd_caller.to_variant());
				
				let callable = callable.get();
				if !callable.is_valid() {
					// Adding the `callable` to the msg does provide additional info, like it's name if it has one.
					return Err(wasmtime::Error::msg(format!("Callable is invalid! ({})", callable)));
				}
				let result = callable.call(&varargs);

				if let Ok(mut err) = result.try_to::<Gd<WasmError>>() {
					let error = err.bind_mut().error.take()
						.ok_or_else(|| wasmtime::Error::msg("WasmError's error was already taken! Do not reuse WasmError!"))?;
					return Err(error);
				}
				
				match results.len() {
					0 => {},
					1 => results[0] = func_type.result(0).unwrap().val_from(result, &mut gd_caller.clone().bind_mut().as_context_mut()).into_trap("results[0]")?,
					len => {
						let array: Array<Variant> = result.try_to().into_trap("Expected return of Array[Variant]")?;
						if len != array.len() {
							return Err(wasmtime::Error::msg(format!("Incorrect return value count, expected {} but got {}", len, array.len())));
						}
						for i in 0..len {
							results[i] = func_type.result(i).unwrap().val_from(array.at(i), &mut gd_caller.clone().bind_mut().as_context_mut()).into_trap(&format!("results[{}]", i))?;
						}
					}
				}
				return Ok(());
			}
		);

		return Ok(Some(Self::new_from(func, gd_context)));
	}

    /// Returns the func type. The contents may change in the future, only pass this value back to wasmtime-gd.
	#[func]
	fn get_func_type(&mut self) -> Variant {
		let dyn_context = self.context.dyn_bind();
		let context = &mut dyn_context.as_context();
		return self.func.ty(context).to_variant();
	}

	/// Get the types this func returns. The contents may change in the future, only pass this value back to wasmtime-gd.
	#[func]
	fn get_param_types(&mut self) -> Array<Variant> {
		let dyn_context = self.context.dyn_bind();
		let context = &mut dyn_context.as_context();
		return Array::from_iter(self.func.ty(context).params().map(|ty| ty.to_variant()));
	}

	/// Get the types this func returns. The contents may change in the future, only pass this value back to wasmtime-gd.
	#[func]
	fn get_result_types(&mut self) -> Array<Variant> {
		let dyn_context = self.context.dyn_bind();
		let context = &mut dyn_context.as_context();
		return Array::from_iter(self.func.ty(context).results().map(|ty| ty.to_variant()));
	}

	fn call_wasm_internal(&mut self, args: Array<Variant>) -> Result<wasmtime::Result<Vec<wasmtime::Val>>, MyGodotError<Variant>> {
		// TODO: If this func belongs to a different store than the current caller, this fails.

		let mut ctx_gd = ACTIVE_CALLERS.with_borrow(|callers| {
			if callers.len() > 0 {
				return callers[callers.len() - 1].clone();
			}
			return self.context.clone();
		});
		let instance_id = ctx_gd.instance_id();
		match ACTIVE_CALL_THREADS.lock().unwrap().entry(instance_id) {
			hash_map::Entry::Vacant(entry) => {
				entry.insert(thread::current_id());
				Ok(())
			},
			hash_map::Entry::Occupied(entry) =>
				Err(MyGodotError::from(format!("Attempt to access context on thread #{} while it's currently used by thread #{}", thread::current_id().as_u64(), entry.get().as_u64()), Variant::nil())),
		}?;
		let _guard = scopeguard::guard((), |_| {
			assert_eq!(ACTIVE_CALL_THREADS.lock().unwrap().remove(&instance_id), Some(thread::current_id()));
		});
		let ctx = ctx_gd.dyn_bind_mut();
		
		let func_type = self.func.ty(ctx.as_context_mut());
		let param_types = func_type.params();

		if args.len() != param_types.len() {
			return Err(MyGodotError::from(format!("Incorrect number or args, expected {} but got {}", param_types.len(), args.len()), Variant::nil()));
		}

		let params = param_types.enumerate().map(|(i, ty)| -> Result<wasmtime::Val, MyGodotError<Variant>> {
			return ty.val_from(args.at(i), ctx.as_context_mut()).or_godot_error(&format!("Invalid arg type arg #{}, expected {}", i, ty), Variant::nil());
		}).collect::<Result<Vec<wasmtime::Val>, MyGodotError<Variant>>>()?;
		
		let mut results = self.func.ty(ctx.as_context_mut()).results().map(|ty| {
			if let Some(val) = ty.default_value() {
				return val;
			}
			return match ty {
				wasmtime::ValType::Ref(r) => wasmtime::Val::null_ref(r.heap_type()),
				_ => unreachable!(),
			};
		}).collect::<Vec<wasmtime::Val>>();

		return Ok(self.func.call(ctx.as_context_mut(), params.as_slice(), results.as_mut_slice()).map(|()| results));
	}

	// https://github.com/godot-rust/gdext/issues/1472
	/// Returns an array of values, or `nil` if the function has no returns. [br]
	/// Otherwise returns [WasmError] in the case of an error and also pushes the error. [br]
	#[func]
	fn call_wasm(&mut self, args: Array<Variant>) -> MyGodotResult<Variant> {
		return match self.call_wasm_internal(args) {
			Ok(result) => match result {
				Ok(results) => match results.len() {
					0 => Ok(Variant::nil()),
					_ => Ok(Array::from_iter(results.iter().map(|val| val.to_variant(self.context.clone()))).to_variant())
				},
				Err(error) => {
					let gd_error = WasmError::new_from_error(error);
					gd_error.bind().print();
					Ok(gd_error.to_variant())
				},
			}
			Err(error) => {
				let gd_error = WasmError::new_from_any_error(anyhow::anyhow!(format!("{}", error)));
				gd_error.bind().print();
				Ok(gd_error.to_variant())
			},
		};
	}

	// https://github.com/godot-rust/gdext/issues/1472
	/// Same as [member call_wasm] except the error is not printed. [br]
	#[func]
	fn call_wasm_catch(&mut self, args: Array<Variant>) -> MyGodotResult<Variant> {
		return match self.call_wasm_internal(args) {
			Ok(result) => match result {
				Ok(results) => match results.len() {
					0 => Ok(Variant::nil()),
					_ => Ok(Array::from_iter(results.iter().map(|val| val.to_variant(self.context.clone()))).to_variant())
				},
				Err(error) => Ok(WasmError::new_from_error(error).to_variant()),
			}
			Err(error) => Ok(WasmError::new_from_any_error(anyhow::anyhow!(format!("{}", error))).to_variant()),
		};
	}
}
