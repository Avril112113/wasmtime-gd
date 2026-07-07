use crate::store_data::StoreData;

pub trait ContextStoreSameAs {
	fn same_store_as(&self, other: &Self) -> bool;
}

impl ContextStoreSameAs for wasmtime::StoreContext<'_, StoreData> {
	fn same_store_as(&self, other: &Self) -> bool {
		let ptr_a = self.data() as *const StoreData;
		let ptr_b = other.data() as *const StoreData;
		return std::ptr::eq(ptr_a, ptr_b);
	}
}
