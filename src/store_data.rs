use std::{cell::RefCell, rc::Rc};


#[derive(Debug)]
pub struct StoreData {
	pub store: Option<Rc<RefCell<wasmtime::Store<StoreData>>>>,
	pub call_fuel_use: u64,
}

impl StoreData {
	pub(crate) fn new() -> Self {
		Self {
			store: None,
			call_fuel_use: 10000,
		}
	}
}
