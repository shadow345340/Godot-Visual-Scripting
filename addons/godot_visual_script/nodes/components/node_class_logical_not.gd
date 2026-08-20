@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Not (!)"

func get_category() -> String:
	return "Conditionals"

func get_header_color() -> Color:
	return Color(0.45, 0.1, 0.2)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Value", "type": VisualPortTypes.PortType.BOOL}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Inverted", "type": VisualPortTypes.PortType.BOOL}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var val = inputs.get("Value", false)
	return {"Inverted": not val}
