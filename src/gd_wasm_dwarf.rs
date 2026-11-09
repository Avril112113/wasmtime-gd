use std::collections::HashMap;

use godot::prelude::*;
use gimli::{AttributeValue, Dwarf, EndianSlice, RunTimeEndian, SectionId};

use crate::utils_errors::{IntoMyGodotOption, IntoMyGodotResult, MyGodotResult};


#[derive(GodotClass)]
#[class(base=RefCounted)]
pub struct WasmDwarf {
	sections: HashMap<SectionId, Vec<u8>>,
}

#[godot_api]
impl IRefCounted for WasmDwarf {
	fn init(_base: Base<Self::Base>) -> Self {
        panic!("WasmDwarf.new() is invalid!");
	}
}

#[godot_api]
impl WasmDwarf {
	#[func]
	fn new_from(bytes: PackedByteArray) -> Option<Gd<Self>> {
		let mut sections = HashMap::<SectionId, Vec<u8>>::new();

		let parser = wasmparser::Parser::new(0);
		for payload in parser.parse_all(bytes.as_slice()) {
			if let wasmparser::Payload::CustomSection(section) = payload.or_print_error("wasmparser section error")? {
				let section_name = match section.name() {
					".debug_abbrev" => Some(SectionId::DebugAbbrev),
					".debug_addr" => Some(SectionId::DebugAddr),
					".debug_aranges" => Some(SectionId::DebugAranges),
					".debug_cu_index" => Some(SectionId::DebugCuIndex),
					".debug_frame" => Some(SectionId::DebugFrame),
					".eh_frame" => Some(SectionId::EhFrame),
					".eh_frame_hdr" => Some(SectionId::EhFrameHdr),
					".debug_gnu_pubnames" => Some(SectionId::DebugGnuPubNames),
					".debug_gnu_pubtypes" => Some(SectionId::DebugGnuPubTypes),
					".debug_info" => Some(SectionId::DebugInfo),
					".debug_line" => Some(SectionId::DebugLine),
					".debug_line_str" => Some(SectionId::DebugLineStr),
					".debug_loc" => Some(SectionId::DebugLoc),
					".debug_loclists" => Some(SectionId::DebugLocLists),
					".debug_macinfo" => Some(SectionId::DebugMacinfo),
					".debug_macro" => Some(SectionId::DebugMacro),
					".debug_names" => Some(SectionId::DebugNames),
					".debug_pubnames" => Some(SectionId::DebugPubNames),
					".debug_pubtypes" => Some(SectionId::DebugPubTypes),
					".debug_ranges" => Some(SectionId::DebugRanges),
					".debug_rnglists" => Some(SectionId::DebugRngLists),
					".debug_str" => Some(SectionId::DebugStr),
					".debug_str_offsets" => Some(SectionId::DebugStrOffsets),
					".debug_tu_index" => Some(SectionId::DebugTuIndex),
					".debug_types" => Some(SectionId::DebugTypes),
					_ => None
				};

				if let Some(section_id) = section_name {
					let mut data = Vec::<u8>::new();
					section.data().clone_into(&mut data);
					sections.entry(section_id).insert_entry(data);
				}
			}
		}

		return Some(Gd::from_object(Self {
			sections,
		}));
	}

    fn get_dwarf_view(&self) -> Dwarf<EndianSlice<'_, RunTimeEndian>> {
        Dwarf::load(|id| -> Result<EndianSlice<'_, RunTimeEndian>, gimli::Error> {
            let bytes = self.sections.get(&id).map(|v| v.as_slice()).unwrap_or(&[]);
            Ok(EndianSlice::new(bytes, RunTimeEndian::Little))
        }).unwrap()
    }

	#[func]
	fn get_func_param_names(&self, target_func_name: String) -> MyGodotResult<Variant> {
		let dwarf = self.get_dwarf_view();
		
		let mut param_names = Array::<Variant>::new();
		let mut has_function = false;
		let mut has_named_params = false;

		let mut iter = dwarf.units();
		while let Some(header) = iter.next().or_godot_error("DWARF next error", Variant::nil())? {
			let unit = dwarf.unit(header).or_godot_error("DWARF unit error", Variant::nil())?;
			let mut entries = unit.entries();

			let mut should_process_args = false;
			while let Some(entry ) = entries.next_dfs().or_godot_error("DWARF next_dfs error", Variant::nil())? {
				if entry.tag() == gimli::DW_TAG_subprogram {
					should_process_args = false;

					if let Some(name_attr) = entry.attr_value(gimli::DW_AT_name) {
						if let Ok(name_str) = dwarf.attr_string(&unit, name_attr) {
							if name_str.to_string_lossy() == target_func_name {
								should_process_args = true;
							} else {
								continue;
							}
						}
					}
					if let Some(decl_attr) = entry.attr_value(gimli::DW_AT_declaration) {
						if let AttributeValue::Flag(b) = decl_attr && b {
							should_process_args = false;
							continue;
						}
					}

					if should_process_args {
						has_function = true;
						param_names.clear();
					}
				} else if should_process_args {
					if entry.tag() == gimli::DW_TAG_formal_parameter {
						if let Some(param_name_attr) = entry.attr_value(gimli::DW_AT_name) {
							if let Ok(param_str) = dwarf.attr_string(&unit, param_name_attr) {
								param_names.push(param_str.to_string_lossy().into_owned());
								has_named_params = true;
							}
						} else {
							param_names.push(format!("_param_{}", param_names.len()));
						}
					} else if entry.tag() == gimli::DW_TAG_variable {
						if entry.tag() == gimli::DW_TAG_variable {
							if let Some(param_type_attr) = entry.attr_value(gimli::DW_AT_type) {
								if let AttributeValue::UnitRef(param_type_offset) = param_type_attr {
									if let Ok(type_entry) = unit.entry(param_type_offset) {
										if let Some(type_name_attr) = type_entry.attr_value(gimli::DW_AT_name) {
											if let Ok(type_name) = dwarf.attr_string(&unit, type_name_attr) {
												if type_name.to_string_lossy() == "va_list" {
													param_names.push("va_list_argp");
													should_process_args = false;
												}
											}
										}
									}
								}
							}
						}
					} else if entry.tag() == gimli::DW_TAG_unspecified_parameters {
						param_names.push("va_list_argp");
						should_process_args = false;
					} else {
						should_process_args = false;
					}
				}
			}

			if has_function && has_named_params {
				break;
			}
		}

		if !has_function {
			return Ok(Variant::nil());
		}

		return Ok(param_names.to_variant());
	}
}
