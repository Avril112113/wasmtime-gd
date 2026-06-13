mod traits;
pub use traits::WasmAsExtern;

mod val_utils;
pub use val_utils::ValFromVariantByValType;
pub use val_utils::ValIntoVariant;

pub mod gd_wasm_global;
pub mod gd_wasm_func;
