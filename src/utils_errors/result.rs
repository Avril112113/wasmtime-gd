
use godot::{global::{PrintRecord, print_custom}, meta::{Element, error::{CallOutcome, ErrorToGodot}}};

use crate::gd_script_stuff::{GDScriptStuff, ToPrintSourceOption};


pub(crate) type MyGodotResult<T, E = MyGodotError<T>> = Result<T, E>;

pub(crate) struct MyGodotError<T> { pub value: T, pub msg: String, pub err: Option<Box<dyn std::fmt::Display + 'static>> }

impl<T> MyGodotError<T> {
	/// Makes the Rust error not printed to Godot.
	pub fn without_err(self) -> Self {
		return Self {
			value: self.value,
			msg: self.msg,
			err: None,
		};
	}

	pub fn with_value<TNew>(self, new_value: TNew) -> MyGodotError::<TNew> {
		return MyGodotError::<TNew> {
			value: new_value,
			msg: self.msg,
			err: self.err,
		};
	}
}

impl<T: Element> ErrorToGodot<T> for MyGodotError<T> {
	type Mapped = T;

	fn result_to_godot(result: Result<T, Self>) -> CallOutcome<Self::Mapped> {
		return match result {
			Ok(value) => CallOutcome::Return(value),
			Err(MyGodotError { value, msg, err }) => {
				let frame_info = GDScriptStuff::get_last_frame_info();
				let source = frame_info.to_print_source();
				
				let message = if let Some(err) = err.as_ref() {
					format!("{}: {}", msg, err)
				} else {
					format!("{}", msg)
				};

				print_custom(PrintRecord {
					level: godot::global::PrintLevel::Error,
					message: message.as_str(),
					rationale: None,
					source,
					editor_notify: false,
				});
				return CallOutcome::Return(value);
			},
		};
	}
}


pub(crate) trait IntoMyGodotResult<TRes,TErrRes> {
	fn or_godot_error(self, err_msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>>;

	fn or_godot_error_fn(self, err_msg: &str, err_fn: impl FnOnce() -> TErrRes) -> Result<TRes, MyGodotError<TErrRes>>;
}

impl<TRes, TErrRes, TErr:std::fmt::Display + 'static> IntoMyGodotResult<TRes,TErrRes> for Result<TRes,TErr> {
	fn or_godot_error(self, msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.map_err(|err| MyGodotError { value: err_value, msg: msg.into(), err: Some(Box::new(err)) });
	}

	fn or_godot_error_fn(self, msg: &str, err_fn: impl FnOnce() -> TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.map_err(|err| MyGodotError { value: err_fn.call_once(()), msg: msg.into(), err: Some(Box::new(err)) });
	}
}

impl<TRes,TErrRes> IntoMyGodotResult<TRes,TErrRes> for Option<TRes> {
	fn or_godot_error(self, msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.ok_or(MyGodotError { value: err_value, msg: msg.into(), err: None });
	}

	fn or_godot_error_fn(self, msg: &str, err_fn: impl FnOnce() -> TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.ok_or(MyGodotError { value: err_fn.call_once(()), msg: msg.into(), err: None });
	}
}

// Due to Rust complaining about a possibility, this must be a unique trait :/
pub(crate) trait IntoMyGodotResultAlt<TRes,TErrRes> {
	fn or_godot_error(self, err_msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>>;
}

impl<TRes, TErrRes> IntoMyGodotResultAlt<TRes,TErrRes> for Result<TRes,()> {
	fn or_godot_error(self, msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.map_err(|_| MyGodotError { value: err_value, msg: msg.into(), err: None });
	}
}


pub(crate) trait IntoMyGodotResultImpl<TRes,TErrRes> {
	fn without_err(self) -> Result<TRes, MyGodotError<TErrRes>>;
	fn with_err_value<TErrResNew>(self, value: TErrResNew) -> Result<TRes, MyGodotError<TErrResNew>>;
}

impl<TRes, TErrRes> IntoMyGodotResultImpl<TRes,TErrRes> for Result<TRes,MyGodotError<TErrRes>> {
	/// Makes the Rust error not printed to Godot.
	fn without_err(self) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.map_err(MyGodotError::without_err);
	}
	
	fn with_err_value<TErrResNew>(self, value: TErrResNew) -> Result<TRes, MyGodotError<TErrResNew>> {
		return self.map_err(|err| MyGodotError::with_value(err, value));
	}
}