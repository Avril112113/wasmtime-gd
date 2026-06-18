use godot::global::{PrintRecord, print_custom};

use crate::gd_script_stuff::{GDScriptStuff, ToPrintSourceOption};


pub(crate) trait IntoMyGodotOption<TRes> {
	fn or_print_error(self, err_msg: &str) -> Option<TRes>;
}

impl<TRes, TErr:Into<anyhow::Error>> IntoMyGodotOption<TRes> for Result<TRes,TErr> {
	fn or_print_error(self, msg: &str) -> Option<TRes> {
		if let Err(err) = self {
			let frame_info = GDScriptStuff::get_last_frame_info();
			let source = frame_info.to_print_source();
			
			print_custom(PrintRecord {
				level: godot::global::PrintLevel::Error,
				message: format!("{}: {}", msg, &err.into().to_string()).as_str(),
				rationale: None,
				source,
				editor_notify: false,
			});
			return None;
		} else {
			return self.ok();
		}
	}
}

impl<TRes> IntoMyGodotOption<TRes> for Option<TRes> {
	fn or_print_error(self, msg: &str) -> Option<TRes> {
		if self.is_none() {
			let frame_info = GDScriptStuff::get_last_frame_info();
			let source = frame_info.to_print_source();
			
			print_custom(PrintRecord {
				level: godot::global::PrintLevel::Error,
				message: msg,
				rationale: None,
				source,
				editor_notify: false,
			});
			return None;
		} else {
			return self;
		}
	}
}
