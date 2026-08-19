@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Whole Number"

func get_category() -> String:
	return "Variables"

func get_header_color() -> Color:
	return Color(0.1, 0.45, 0.25)

func get_inputs() -> Array[Dictionary]:
	return []

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Value", "type": VisualPortTypes.PortType.INT}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var value_int = 0
	if context and context.has_meta("int_input_value"):
		value_int = context.get_meta("int_input_value")
	return {"Value": value_int}
