#[derive(Debug)]
pub(crate) struct StoreData {
	pub call_fuel_use: u64,
}

impl StoreData {
	pub(crate) fn new() -> Self {
		Self {
			call_fuel_use: 10000,
		}
	}
}
