use std::{cell::RefCell, collections::{HashMap, hash_map}, sync::{LazyLock, Mutex}, thread::{self, ThreadId}};

use godot::prelude::*;

use crate::{store_data::StoreData, utils::{ContextGuard, ContextGuardMut, GdAsContext}, utils_errors::{MyGodotError, MyGodotResult}};


thread_local! {
	pub(crate) static ACTIVE_CALLERS: RefCell<HashMap<usize, Vec<DynGd<RefCounted, dyn GdAsContext>>>> = RefCell::new(HashMap::new());
}
static ACTIVE_CALL_THREADS: Mutex<LazyLock<HashMap<InstanceId, ThreadId>>> = Mutex::new(LazyLock::new(HashMap::new));


#[derive(Clone, Debug)]
pub struct WasmContext {
    pub store_id: usize,
    pub gd: DynGd<RefCounted, dyn GdAsContext>,
}

impl WasmContext {
    /// Safe outside a host call (normal construction).
    pub fn new(gd: DynGd<RefCounted, dyn GdAsContext>) -> Self {
        let store_id = (gd.dyn_bind().as_context().data() as *const StoreData).addr();
        Self { store_id, gd }
    }

    /// For propagation from a wrapper that already has a context.
    pub fn from_parts(gd: DynGd<RefCounted, dyn GdAsContext>, store_id: usize) -> Self {
        Self { store_id, gd }
    }

    pub fn active(&self) -> DynGd<RefCounted, dyn GdAsContext> {
		return ACTIVE_CALLERS
			.with_borrow(|callers| {
				callers.get(&self.store_id)?.last().cloned()
			})
			.unwrap_or(self.gd.clone());
    }

	pub fn lock_active_to_thread_scoped(&self) -> MyGodotResult<scopeguard::ScopeGuard<(), impl FnOnce(()) + use<>>, MyGodotError<()>> {
		let instance_id = self.gd.instance_id();
		let thread_id = thread::current_id();
		let new_lock = match ACTIVE_CALL_THREADS.lock().unwrap().entry(instance_id) {
			hash_map::Entry::Vacant(entry) => {
				entry.insert(thread_id);
				Ok(true)
			},
			hash_map::Entry::Occupied(entry) if *entry.get() == thread_id =>
				Ok(false),
			hash_map::Entry::Occupied(entry) =>
				Err(MyGodotError::from(format!("Attempt to access context on thread #{} while it's currently used by thread #{}", thread_id.as_u64(), entry.get().as_u64()), ())),
		}?;
		return Ok(scopeguard::guard((), move |_| {
			if new_lock {
				assert_eq!(ACTIVE_CALL_THREADS.lock().unwrap().remove(&instance_id), Some(thread_id));
			}
		}));
	}

	pub fn push_active_call_scoped(gd: DynGd<RefCounted, dyn GdAsContext>) -> scopeguard::ScopeGuard<(), impl FnOnce(())> {
		let store_id = (gd.dyn_bind().as_context().data() as *const StoreData).addr();
		ACTIVE_CALLERS.with_borrow_mut(|callers| {
			callers.entry(store_id)
				.or_default()
				.push(gd.clone());
		});
		return scopeguard::guard((), move |_| {
			ACTIVE_CALLERS.with_borrow_mut(|callers| {
				let Some(contexts) = callers.get_mut(&store_id) else {
					debug_assert!(false, "active caller stack missing for store {store_id:#x}");
					return;
				};
				debug_assert!(contexts.pop().is_some(), "active caller stack empty for store {store_id:#x}");
				if contexts.len() == 0 {
					callers.remove(&store_id).unwrap();
				}
			});
		});
	}
}

impl WasmContext {
	pub fn as_context(&self) -> ContextGuard<'_> {
		return ContextGuard::new_for(self.active().dyn_bind().get_context());
	}

	pub fn as_context_mut(&self) -> ContextGuardMut<'_> {
		return ContextGuardMut::new_for(self.active().dyn_bind().get_context());
	}
}

impl GodotConvert for WasmContext {
	type Via = Gd<RefCounted>;

	fn godot_shape() -> godot::meta::shape::GodotShape {
		return <DynGd<RefCounted, dyn GdAsContext> as GodotConvert>::godot_shape();
	}
}

impl ToGodot for WasmContext {
	type Pass = godot::meta::conv::ByValue;

	fn to_godot(&self) -> godot::meta::ToArg<'_, Self::Via, Self::Pass> {
		return self.gd.to_godot().clone();
	}
}

impl FromGodot for WasmContext {
	fn try_from_godot(via: Self::Via) -> Result<Self, ConvertError> {
		let dyn_gd = DynGd::<RefCounted, dyn GdAsContext>::try_from_godot(via)?;
        return Ok(Self::new(dyn_gd));
	}
}
