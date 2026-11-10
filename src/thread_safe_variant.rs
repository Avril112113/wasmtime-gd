use std::{sync::{Arc, Mutex}, thread::ThreadId};

use godot::prelude::*;

#[derive(Clone, Debug)]
pub(crate) struct ThreadVariant {
    inner: Arc<Mutex<Inner>>,
}

#[derive(Debug)]
struct Inner {
    value: Variant,
    owner: ThreadId,
}

unsafe impl Send for ThreadVariant {}
unsafe impl Sync for ThreadVariant {}

impl ThreadVariant {
    pub fn new(value: Variant) -> Self {
        Self {
            inner: Arc::new(Mutex::new(Inner {
                value,
                owner: std::thread::current().id(),
            })),
        }
    }

    pub fn get(&self) -> Variant {
		let inner = self.inner.lock().unwrap();
        if std::thread::current().id() != inner.owner {
			if let Err(reason) = Self::is_thread_safe(&inner.value) {
				panic!("{}", reason);
			}
        }
		return inner.value.clone();
    }

    pub fn into_inner(self) -> Variant {
		let mut inner = self.inner.lock().unwrap();
        if std::thread::current().id() != inner.owner {
			if let Err(reason) = Self::is_thread_safe(&inner.value) {
				panic!("{}", reason);
			}
        }
		return std::mem::replace(&mut inner.value, Variant::nil());
    }

    fn is_thread_safe(v: &Variant) -> Result<(), String> {
        match v.get_type() {
            VariantType::NIL
            | VariantType::BOOL
            | VariantType::INT
            | VariantType::FLOAT
            | VariantType::STRING
            | VariantType::VECTOR2
            | VariantType::VECTOR2I
            | VariantType::RECT2
            | VariantType::RECT2I
            | VariantType::VECTOR3
            | VariantType::VECTOR3I
            | VariantType::TRANSFORM2D
            | VariantType::VECTOR4
            | VariantType::VECTOR4I
            | VariantType::PLANE
            | VariantType::QUATERNION
            | VariantType::AABB
            | VariantType::BASIS
            | VariantType::TRANSFORM3D
            | VariantType::PROJECTION
            | VariantType::COLOR
            | VariantType::STRING_NAME
            | VariantType::NODE_PATH
            | VariantType::RID
            // | VariantType::OBJECT
            // | VariantType::CALLABLE
            // | VariantType::SIGNAL
            // | VariantType::DICTIONARY
            // | VariantType::ARRAY
            | VariantType::PACKED_BYTE_ARRAY
            | VariantType::PACKED_INT32_ARRAY
            | VariantType::PACKED_INT64_ARRAY
            | VariantType::PACKED_FLOAT32_ARRAY
            | VariantType::PACKED_FLOAT64_ARRAY
            | VariantType::PACKED_STRING_ARRAY
            | VariantType::PACKED_VECTOR2_ARRAY
            | VariantType::PACKED_VECTOR3_ARRAY
            | VariantType::PACKED_COLOR_ARRAY
            | VariantType::PACKED_VECTOR4_ARRAY
            => Ok(()),

            VariantType::ARRAY => {
                let arr = v.to::<Array<Variant>>();
                for item in arr.iter_shared() {
                    Self::is_thread_safe(&item)?;
                }
                Ok(())
            }

            VariantType::DICTIONARY => {
                let dict = v.to::<Dictionary<Variant,Variant>>();
                for (_, value) in dict.iter_shared() {
                    Self::is_thread_safe(&value)?;
                }
                Ok(())
            }

            _ => Err(format!("Variant type {:?} is not thread-safe to move across threads", v.get_type())),
        }
    }
}
