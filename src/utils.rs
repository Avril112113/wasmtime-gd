use std::{cell::{Ref, RefCell, RefMut}, ops::{Deref, DerefMut}, rc::Rc};

use wasmtime::{AsContext, AsContextMut, StoreContext, StoreContextMut};

use crate::store_data::StoreData;


pub trait GdAsContext {
	fn get_context(&self) -> Rc<RefCell<dyn AsContextMut<Data = StoreData>>>;

	fn as_context(&self) -> ContextGuard<'_> {
		let rc = self.get_context();
		
		// 1. Unsafely extend the borrow lifetime so we can bundle it into the struct.
		// This is safe because the 'rc' cloning is bundled right next to it, 
		// ensuring the underlying memory allocation outlives the guard.
		let borrow = unsafe {
			std::mem::transmute::<
				Ref<'_, dyn AsContextMut<Data = StoreData>>,
				Ref<'_, dyn AsContextMut<Data = StoreData>>
			>(rc.borrow())
		};
		
		let context = unsafe {
			std::mem::transmute::<StoreContext<'_, StoreData>, StoreContext<'_, StoreData>>(
				borrow.as_context()
			)
		};
		
		return ContextGuard { _rc: rc, _borrow: borrow, context };
	}

	fn as_context_mut(&self) -> ContextGuardMut<'_> {
		let rc = self.get_context();
		
		let mut borrow = unsafe {
			std::mem::transmute::<
				RefMut<'_, dyn AsContextMut<Data = StoreData>>,
				RefMut<'_, dyn AsContextMut<Data = StoreData>>
			>(rc.borrow_mut())
		};
		
		let context = unsafe {
			std::mem::transmute::<StoreContextMut<'_, StoreData>, StoreContextMut<'_, StoreData>>(
				borrow.as_context_mut()
			)
		};
		
		return ContextGuardMut { _rc: rc, _borrow: borrow, context };
	}
}



// 1. Updated Guards that own the Rc to keep it alive
pub struct ContextGuard<'a> {
	_borrow: Ref<'a, dyn AsContextMut<Data = StoreData>>,
	context: StoreContext<'a, StoreData>,
	// SAFETY: Rc is dropped after the borrow is dropped.
	_rc: Rc<RefCell<dyn AsContextMut<Data = StoreData>>>,
}

impl<'a> AsContext for ContextGuard<'a> {
	type Data = StoreData;
	fn as_context(&self) -> StoreContext<'_, Self::Data> {
		return self.context.as_context();
	}
}

pub struct ContextGuardMut<'a> {
	_rc: Rc<RefCell<dyn AsContextMut<Data = StoreData>>>,
	_borrow: RefMut<'a, dyn AsContextMut<Data = StoreData>>,
	context: StoreContextMut<'a, StoreData>,
}

impl<'a> AsContext for ContextGuardMut<'a> {
	type Data = StoreData;
	fn as_context(&self) -> StoreContext<'_, Self::Data> {
		return self.context.as_context();
	}
}

impl<'a> AsContextMut for ContextGuardMut<'a> {
	fn as_context_mut(&mut self) -> StoreContextMut<'_, Self::Data> {
		return self.context.as_context_mut();
	}
}

// 1. Allow ContextGuard to automatically act as a StoreContext
impl<'a> Deref for ContextGuard<'a> {
	type Target = StoreContext<'a, StoreData>;

	fn deref(&self) -> &Self::Target {
		&self.context
	}
}

// 2. Allow ContextGuardMut to automatically act as a StoreContextMut
impl<'a> Deref for ContextGuardMut<'a> {
	type Target = StoreContextMut<'a, StoreData>;

	fn deref(&self) -> &Self::Target {
		&self.context
	}
}

// 3. Optional: If you want to modify things inside StoreContextMut directly
impl<'a> DerefMut for ContextGuardMut<'a> {
	fn deref_mut(&mut self) -> &mut Self::Target {
		&mut self.context
	}
}
