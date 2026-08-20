@tool
extends ResourceFormatLoader
class_name VisualScriptLoader

func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["gvs"])

func _handles_type(type: StringName) -> bool:
	return type == &"Resource" or type == &"PackedDataContainer"

func _get_resource_type(_path: String) -> String:
	return "PackedDataContainer"
