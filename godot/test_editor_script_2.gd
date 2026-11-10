@tool
extends EditorScript


func _run() -> void:
	print("~~~~~ TEST")
	
	var clock := Wasip1ClockRealtime.new()
	var vfs := Wasip1Vfs.new(clock)
	
	var box := LuaBox.new(vfs)
	print(box._exports.__c_longjmp)
