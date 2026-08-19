@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Text Value"

func get_category() -> String:
	return "Variables"

func get_header_color() -> Color:
	return Color(0.1, 0.4, 0.45)

func get_inputs() -> Array[Dictionary]:
	return []

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Value", "type": VisualPortTypes.PortType.STRING}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var value_string = ""
	if context and context.has_meta("text_input_value"):
		value_string = context.get_meta("text_input_value")
	return {"Value": value_string}
