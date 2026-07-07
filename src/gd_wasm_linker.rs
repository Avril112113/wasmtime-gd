use godot::prelude::*;

use crate::store_data::StoreData;
use crate::{
    gd_wasm_engine::WasmEngine, gd_wasm_instance::WasmInstance, gd_wasm_module::WasmModule, gd_wasm_store::WasmStore,
    utils_errors::*, wasm_types::WasmAsExtern
};


/// A Wasmtime Linker, to link wasm modules/instances together and provide imports from the host.
/// 
/// **DO NOT USE `WasmLinker.new()` it will return null.**
#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmLinker {
	pub linker: wasmtime::Linker<StoreData>,
}

#[godot_api]
impl IRefCounted for WasmLinker {
    fn init(_base: Base<Self::Base>) -> Self {
        panic!("WasmLinker.new() is invalid!");
    }
}

#[godot_api]
impl WasmLinker {
    /// Create a new [WasmLinker], which is used to link wasm modules/instances together.
    #[func]
    fn new_with(engine: Gd<WasmEngine>) -> Gd<Self> {
		return Gd::from_object(Self {
            linker: wasmtime::Linker::new(&engine.bind().engine),
        });
    }

    /// May return `null` in case of error, which will be logged.
    #[func]
    fn instantiate(&mut self, mut store: Gd<WasmStore>, module: Gd<WasmModule>) -> Option<Gd<WasmInstance>> {
        let instance = self.linker.instantiate(&mut store.bind_mut().store, &module.bind().module)
            .or_print_error("Failed to create Instance:")?;
        
        return Some(Gd::from_object(WasmInstance::new(instance, store)));
    }

    /// [param wasm_extern] may be one of the following;
    /// - [WasmGlobal]
    /// - TODO: The other Extern types.
    #[func]
    fn define(&mut self, mut store: Gd<WasmStore>, module: GString, name: GString, wasm_extern: DynGd<RefCounted, dyn WasmAsExtern>) -> bool {
        let extern_val = wasm_extern.dyn_bind().as_extern();
        return self.linker.define(&mut store.bind_mut().store, &module.to_string(), &name.to_string(), extern_val)
            .or_print_error(&format!("Failed to define \"{}::{}\"", module, name))
            .is_some();
    }

    /// Simply calls the [param callable] with this linker and [param store] as arguments.
    /// 
    /// This allows `linker.define_feature(store, MyFeature.define_feature)` pattern.
    #[func(gd_self)]
    fn define_feature(gd_self: Gd<Self>, store: Gd<WasmStore>, callable: Callable) -> Variant {
        return callable.call(&vec![gd_self.to_variant(), store.to_variant()]);
    }
}
