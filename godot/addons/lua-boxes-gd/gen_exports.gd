@tool
extends EditorScript


const gd_keywords := ["preload", "load", "func"]

const HEAD_COMMENT := """
## 4.6 – Functions and Types [br]
##  [br]
## Here we list all functions and types from the C API in alphabetical order. Each function has an indicator like this: [br]
## [-o, +p, x] [br]
## [br]
## The first field, o, is how many elements the function pops from the stack. [br]
## The second field, p, is how many elements the function pushes onto the stack. (Any function always pushes its results after popping its arguments.) [br]
## A field in the form x|y means the function can push (or pop) x or y elements, depending on the situation; an interrogation mark '?' means that we cannot know how many elements the function pops/pushes by looking only at its arguments. (For instance, they may depend on what is in the stack.) [br]
## The third field, x, tells whether the function may raise errors: [br]
## - '-' means the function never raises any error; [br]
## - 'm' means the function may raise only out-of-memory errors; [br]
## - 'v' means the function may raise the errors explained in the text; [br]
## - 'e' means the function can run arbitrary Lua code, either directly or through metamethods, and therefore may raise any errors. [br]

"""


func _xml_try_get(xml: XMLParser, path: Array[String]) -> bool:
	var start_offset := xml.get_node_offset()
	
	var is_first := true
	
	for part in path:
		if not is_first:
			if xml.read() == ERR_FILE_EOF:
				xml.seek(start_offset)
				return false
		elif is_first:
			is_first = false
		
		if part.begins_with("<") and part.ends_with(">"):
			var node_name := part.substr(1, len(part)-2)
			
			while xml.get_node_type() != XMLParser.NODE_ELEMENT and xml.read() != ERR_FILE_EOF:
				pass
			
			if xml.get_node_name() != node_name:
				xml.seek(start_offset)
				return false
			
			continue
	
	return true

func _xml_get_attributes(xml: XMLParser) -> Dictionary[String, Variant]:
	var attrs: Dictionary[String, Variant] = {}
	for i in range(xml.get_attribute_count()):
		attrs[xml.get_attribute_name(i)] = xml.get_attribute_value(i)
	return attrs
	
func _xml_to_gd_doc(xml: XMLParser, lines: PackedStringArray):
	var open_tags: Dictionary[String, int] = {}
	var to_close_anchors: Array[String] = []
	var within_code := false
	
	var current_line := PackedStringArray()
	
	# TODO: Consume all the way until we hit a `<hr>`
	while true:
		var start_offset := xml.get_node_offset()
		if xml.read() == ERR_FILE_EOF:
			break
		
		if xml.get_node_type() == XMLParser.NODE_ELEMENT:
			var tag_name := xml.get_node_name()
			if tag_name == "hr":
				xml.seek(start_offset)
				break
			
			if not tag_name in open_tags:
				open_tags[tag_name] = 1
			else:
				open_tags[tag_name] += 1
			
			if tag_name == "p":
				if len(current_line) > 0:
					lines.append("".join(current_line))
					current_line.clear()
			elif tag_name == "a":
				var attrs := _xml_get_attributes(xml)
				if "href" in attrs and attrs["href"].begins_with("#"):
					if attrs["href"].begins_with("#lua"):
						current_line.append("[method %s]" % [attrs["href"].substr(1)])
						to_close_anchors.append("")
						xml.skip_section()
					else:
						if not within_code:
							current_line.append("[code]")
							to_close_anchors.append("[/code]")
							within_code = true
						else:
							to_close_anchors.append("")
				else:
					to_close_anchors.append("")
			elif tag_name == "code" or tag_name == "pre":
				if not within_code:
					current_line.append("[code]")
					within_code = true
		elif xml.get_node_type() == XMLParser.NODE_ELEMENT_END:
			var tag_name := xml.get_node_name()
			open_tags[tag_name] -= 1
			
			if tag_name == "a":
				var s := to_close_anchors.pop_back()
				if within_code and s == "[/code]":
					within_code = false
					current_line.append(s)
				elif not within_code:
					current_line.append(s)
			elif tag_name == "code" or tag_name == "pre":
				if within_code:
					current_line.append("[/code]")
					within_code = false
				if tag_name == "pre":
					if len(current_line) > 0:
						lines.append("".join(current_line))
						current_line.clear()
					lines.append("")
			elif tag_name == "span":
				if len(current_line) > 0:
					lines.append("".join(current_line))
					current_line.clear()
		elif xml.get_node_type() == XMLParser.NODE_TEXT:
			current_line.append(
				xml.get_node_data()
					.replace("&nbsp;", " ")
					.replace("&ndash;", "–")
					.replace("&amp;", "&")
					.replace("&lt;", "<")
					.replace("&gt;", ">")
					.replace("&sect;", "§")
					.replace("\n", " ")
			)
	
	if len(current_line) > 0:
		lines.append("".join(current_line))
		current_line.clear()

func _run() -> void:
	var docs_xml := XMLParser.new()
	docs_xml.open("res://addons/lua-boxes-gd/lua-doc/manual.html")
	
	var docs: Dictionary[String, PackedStringArray] = {}
	
	while docs_xml.read() != ERR_FILE_EOF:
		if docs_xml.get_node_type() == XMLParser.NODE_ELEMENT:
			if _xml_try_get(docs_xml, ["<hr>", "<h3>", "<a>"]):
				var attrs := _xml_get_attributes(docs_xml)
				if "name" in attrs and not attrs["name"].begins_with("pdf-"):
					var fn_name: String = attrs["name"]
					var lines := PackedStringArray()
					docs[fn_name] = lines
					docs_xml.skip_section()
					assert(docs_xml.get_node_type() == XMLParser.NODE_ELEMENT_END and docs_xml.get_node_name() == "a", docs_xml.get_node_name())
					docs_xml.skip_section()
					assert(docs_xml.get_node_type() == XMLParser.NODE_ELEMENT_END and docs_xml.get_node_name() == "h3", docs_xml.get_node_name())
					_xml_to_gd_doc(docs_xml, lines)
	
	
	LuaBox.__ensure_init(true)
	
	var exports := LuaBox._module.get_exports()
	var lines_defs := PackedStringArray()
	lines_defs.push_back("extends RefCounted")
	lines_defs.push_back("class_name LuaWasmExports")
	lines_defs.push_back("")
	
	lines_defs.append(HEAD_COMMENT)
	
	var lines_init = PackedStringArray()
	lines_init.push_back("")
	lines_init.push_back("func _init(instance: WasmInstance):")
	
	for name: String in exports.keys():
		var wasm_type: Variant = exports[name]
		var gd_name := name
		if name == "free" or name == "malloc" or name == "calloc":
			gd_name = "_"+name
		lines_defs.push_back("# %s" % [wasm_type])
		lines_init.push_back("\t# %s" % [wasm_type])
		match wasm_type[0]:
			"memory":
				lines_defs.push_back("var %s: WasmMemory" % [gd_name])
				lines_init.push_back("\tself.%s = instance.get_memory(\"%s\")" % [gd_name, name])
			"table":
				lines_defs.push_back("var %s: WasmTable" % [gd_name])
				lines_init.push_back("\tself.%s = instance.get_table(\"%s\")" % [gd_name, name])
			"func_type":
				var args := LuaBox._dwarf.get_func_param_names(name)
				
				if args != null and len(wasm_type[1]) != len(args):
					printerr("WASM func type for '%s' had %s arguments but the DWARF found %s: %s" % [name, len(wasm_type[1]), len(args), args])
					args = null
				elif args == null:
					printerr("Missing DWARF for '%s'" % [name])
				
				var has_arg_names := args != null
				if not has_arg_names:
					args = PackedStringArray()
				else:
					for i in range(len(args)):
						if args[i] in gd_keywords:
							args[i] = args[i] + "_"
				
				var params := PackedStringArray()
				for i in range(len(wasm_type[1])):
					var param_type = wasm_type[1][i]
					var godot_type = "Variant"
					match param_type:
						WasmTypes.I32, WasmTypes.I64:
							godot_type = "int"
						WasmTypes.F32, WasmTypes.F64:
							godot_type = "float"
						_:
							print("WARN: Func export '%s' has unhandled argument %s type '%s'" % [name, i, wasm_type])
					if not has_arg_names:
						args.push_back("_arg%s" % [i])
					params.push_back("%s: %s" % [args[i], godot_type])
				lines_defs.push_back("var __%s: WasmFunc" % [gd_name])
				lines_defs.push_back("## Returns either; an [Array] of results (typically 1 value); or [code]null[/code] if it doesn't return anything; or [WasmError]. [br]")
				lines_defs.push_back("## For details, see [method WasmFunc.call_wasm_catch]")
				if name in docs:
					lines_defs.push_back("## [br][br]")
					for line in docs[name]:
						lines_defs.push_back("## %s [br]" % [line])
				lines_defs.push_back("func %s(%s) -> Variant:" % [gd_name, ", ".join(params)])
				lines_defs.push_back("\treturn self.__%s.call_wasm_catch([%s])" % [gd_name, ", ".join(args)])
				lines_init.push_back("\tself.__%s = instance.get_func(\"%s\")" % [gd_name, name])
			_:
				lines_defs.push_back("# ???")
				lines_init.push_back("\t# ???")
				print("WARN: Export '%s' with unhandled type '%s'" % [name, wasm_type])
		lines_defs.push_back("")
		lines_init.push_back("\t")
	var f := FileAccess.open("res://addons/lua-boxes-gd/lua_wasm_exports.gd", FileAccess.WRITE)
	f.store_string("\n".join(lines_defs + lines_init))
	f.close()
