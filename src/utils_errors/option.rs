use godot::prelude::*;


pub(crate) trait IntoMyGodotOption<TRes> {
	fn or_print_error(self, err_msg: &str) -> Option<TRes>;
}

impl<TRes, TErr:Into<anyhow::Error>> IntoMyGodotOption<TRes> for Result<TRes,TErr> {
	fn or_print_error(self, msg: &str) -> Option<TRes> {
		if let Err(err) = self {
			godot_error!("WasmtimeGd: {}\n{}", msg, err.into());
			return None;
		} else {
			return self.ok();
		}
	}
}

impl<TRes> IntoMyGodotOption<TRes> for Option<TRes> {
	fn or_print_error(self, msg: &str) -> Option<TRes> {
		if self.is_none() {
			godot_error!("WasmtimeGd: {}", msg);
			return None;
		} else {
			return self;
		}
	}
}
