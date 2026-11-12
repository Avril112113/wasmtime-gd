use std::cell::RefCell;

use godot::classes::GDScript;
use godot::global::{PrintRecord, PrintSource, print_custom};
use godot::prelude::*;
use godot::classes::class_macros::private::virtuals::ZipReader::AnyDictionary;


#[macro_export]
macro_rules! get_last_print_source {
	() => {
		$crate::gd_script_stuff::GDScriptStuff::get_frame_print_source(&$crate::gd_script_stuff::GDScriptStuff::get_last_frame_info())
	};
}

pub(crate) struct GDScriptStuff;
impl GDScriptStuff {
	pub fn get_stack() -> Array<AnyDictionary> {
		thread_local! {
			static SCRIPT_CACHE: RefCell<Gd<GDScript>> = RefCell::new({
				let mut script = GDScript::new_gd();
				script.set_source_code("static func _get_stack():\n\tvar stack = get_stack()\n\tstack.pop_front()\n\treturn stack");
				script.reload();
				script
			});
		}
		

		return SCRIPT_CACHE.with_borrow_mut(|script| script.call("_get_stack", &[]).to::<Array<AnyDictionary>>());
	}

	pub fn get_last_frame_info() -> Option<(String, String, u32)> {
		let frame = GDScriptStuff::get_stack().get(0);
		return frame.as_ref().map(|f| (
			f.at("function").to_string(),
			f.at("source").to_string(),
			f.at("line").to::<u32>(),
		));
	}

	pub fn get_frame_print_source<'l>(frame_info: &'l Option<(String, String, u32)>) -> Option<PrintSource<'l>> {
		return frame_info.as_ref().map(|(func, file, line)| godot::global::PrintSource::<'l> {
			function: func.as_str(),
			file: file.as_str(),
			line: *line,
		});
	}

	pub fn print_error(msg: &str, rationale: Option<&str>, source: Option<PrintSource<'_>>) {
		if source.is_some() {
			print_custom(PrintRecord {
				level: godot::global::PrintLevel::Error,
				message: msg,
				rationale,
				source,
				editor_notify: false,
			});
		} else {
			print_custom(PrintRecord {
				level: godot::global::PrintLevel::Error,
				message: msg,
				rationale,
				source: get_last_print_source!(),
				editor_notify: false,
			});
		}
	}
}

pub(crate) trait ToPrintSource {
	fn to_print_source(&self) -> PrintSource<'_>;
}

impl ToPrintSource for (String, String, u32) {
	fn to_print_source<'l>(&'l self) -> PrintSource<'l> {
		godot::global::PrintSource::<'l> {
			function: self.0.as_str(),
			file: self.1.as_str(),
			line: self.2,
		}
	}
}

pub(crate) trait ToPrintSourceOption {
	fn to_print_source(&self) -> Option<PrintSource<'_>>;
}

impl ToPrintSourceOption for Option<(String, String, u32)> {
	fn to_print_source<'l>(&'l self) -> Option<PrintSource<'l>> {
		self.as_ref().map(|fi| fi.to_print_source())
	}
}
