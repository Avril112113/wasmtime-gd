use std::{cell::RefCell, rc::Rc};

use crate::utils::ReentrancyState;

#[derive(Debug)]
pub struct StoreData {
	pub store: Option<Rc<RefCell<wasmtime::Store<StoreData>>>>,
	pub reentrancy: ReentrancyState,
	pub call_fuel_use: u64,
}

impl StoreData {
	pub(crate) fn new() -> Self {
		Self {
			store: None,
			reentrancy: ReentrancyState::default(),
			call_fuel_use: 10000,
		}
	}
}
