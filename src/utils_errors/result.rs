use godot::{meta::{Element, error::{CallOutcome, ErrorToGodot}}, prelude::*};


pub(crate) type MyGodotResult<T, E = MyGodotError<T>> = Result<T, E>;

pub(crate) struct MyGodotError<T> { pub value: T, pub msg: String, pub err: Option<Box<dyn std::fmt::Display + 'static>> }

impl<T: Element> ErrorToGodot<T> for MyGodotError<T> {
	type Mapped = T;

	fn result_to_godot(result: Result<T, Self>) -> CallOutcome<Self::Mapped> {
		return match result {
			Ok(value) => CallOutcome::Return(value),
			Err(MyGodotError { value, msg, err }) => {
				if let Some(err) = err {
					godot_error!("WasmtimeGd: {}\n{}", msg, err);
				} else {
					godot_error!("WasmtimeGd: {}", msg);
				}
				return CallOutcome::Return(value);
			},
		};
	}
}


pub(crate) trait IntoMyGodotResult<TRes,TErrRes> {
	fn or_godot_error(self, err_msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>>;
}

impl<TRes, TErrRes, TErr:std::fmt::Display + 'static> IntoMyGodotResult<TRes,TErrRes> for Result<TRes,TErr> {
	fn or_godot_error(self, msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.map_err(|err| MyGodotError { value: err_value, msg: msg.into(), err: Some(Box::new(err)) });
	}
}

impl<TRes,TErrRes> IntoMyGodotResult<TRes,TErrRes> for Option<TRes> {
	fn or_godot_error(self, msg: &str, err_value: TErrRes) -> Result<TRes, MyGodotError<TErrRes>> {
		return self.ok_or(MyGodotError { value: err_value, msg: msg.into(), err: None });
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
