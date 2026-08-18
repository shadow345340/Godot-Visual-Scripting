@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Branch (If)"

func get_category() -> String:
	return "Flow"

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
