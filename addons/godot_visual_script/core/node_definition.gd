@tool
extends Object
class_name NodeDefinition

func get_node_name() -> String:
	return "Base Node"

func get_category() -> String:
	return "General"

func get_header_color() -> Color:
	return Color(0.2, 0.2, 0.2)

func get_inputs() -> Array[Dictionary]:
	return []

func get_outputs() -> Array[Dictionary]:
	return []
