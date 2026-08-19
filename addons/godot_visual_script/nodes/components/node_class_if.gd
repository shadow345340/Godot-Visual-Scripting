@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Branch"

func get_category() -> String:
	return "Conditionals"

func get_header_color() -> Color:
	return Color(0.5, 0.15, 0.15)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Exec", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "Condition", "type": VisualPortTypes.PortType.BOOL}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "True", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "False", "type": VisualPortTypes.PortType.EXECUTION}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var condition = inputs.get("Condition", false)
	return {
		"True": condition,
		"False": not condition
	}
