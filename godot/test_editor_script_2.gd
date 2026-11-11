@tool
extends EditorScript


func _run() -> void:
	print("~~~~~ TEST SETUP")
	
	var clock := Wasip1ClockRealtime.new()
	var vfs := Wasip1Vfs.new(clock)
	
	var slash_dev := Wasip1VfsVirtualDirectory.new(vfs)
	vfs.vroot.add_child("dev", slash_dev)
	slash_dev.add_child("stdin", Wasip1VfsStreamFile.new(vfs).with_write("".to_utf8_buffer()))
	slash_dev.add_child("stdout", Wasip1VfsStreamFile.new(vfs))
	slash_dev.add_child("stderr", Wasip1VfsStreamFile.new(vfs))
	# Pre-opens
	assert(vfs.open_fd("/dev/stdin", 0) is Wasip1VfsFileDescriptor)
	assert(vfs.open_fd("/dev/stdout", 1) is Wasip1VfsFileDescriptor)
	assert(vfs.open_fd("/dev/stderr", 2) is Wasip1VfsFileDescriptor)
	assert(vfs.open_fd("/", 3) is Wasip1VfsFileDescriptor)
	
	var box := LuaBox.new(vfs)
	
	print("~~~~~ TEST STUFF")
	
	var state := box.new_state()
	state.openlibs()
	
	print(state.lua_registry.lua_get(3))
	
	#var fn: LuaFunction = state.loadstring("return {}")
	#print(fn)
	#print(fn.lua_pcall())
	
	print()
	print(state._state._string_lua_stack())
	
	print("~~~~~ TEST OUT")
	
	var stdout: Wasip1VfsStreamFile = vfs.get_entry("/dev/stdout")
	var stderr: Wasip1VfsStreamFile = vfs.get_entry("/dev/stderr")
	prints("/dev/stdout", stdout.get_filesize())
	if stdout.get_filesize() > 0:
		print(stdout.read_all()[1].get_string_from_utf8())
	prints("/dev/stderr", stderr.get_filesize())
	if stderr.get_filesize() > 0:
		print(stderr.read_all()[1].get_string_from_utf8())
	
	print("~~~~~")
