pub trait ContextStoreSameAs {
	fn same_store_as(&self, other: &Self) -> bool;
}

impl ContextStoreSameAs for wasmtime::StoreContext<'_, ()> {
	fn same_store_as(&self, other: &Self) -> bool {
		let ptr_a = self.data() as *const ();
		let ptr_b = other.data() as *const ();
		return std::ptr::eq(ptr_a, ptr_b);
	}
}
