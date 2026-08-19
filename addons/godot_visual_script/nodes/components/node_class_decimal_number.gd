@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Decimal Number"

func get_category() -> String:
	return "Variables"

func get_header_color() -> Color:
	return Color(0.3, 0.45, 0.1)

func get_inputs() -> Array[Dictionary]:
	return []

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Value", "type": VisualPortTypes.PortType.FLOAT}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var value_float = 0.0
	if context and context.has_meta("float_input_value"):
		value_float = context.get_meta("float_input_value")
	return {"Value": value_float}
