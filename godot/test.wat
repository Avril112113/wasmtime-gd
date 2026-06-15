(module
	(import "env" "test_i32_import" (global $test_i32 (mut i32)))
	(export "test_i32_export" (global $test_i32))

	(import "env" "test_func" (func $test_func (param i32) (result i32)))
	(export "test_func" (func $test_func))


	(memory (export "memory") 0)
)