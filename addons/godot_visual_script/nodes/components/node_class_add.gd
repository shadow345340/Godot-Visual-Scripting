@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Add Values"

func get_category() -> String:
	return "Math"

func get_header_color() -> Color:
	return Color(0.15, 0.4, 0.2)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "A", "type": VisualPortTypes.PortType.INT},
		{"name": "B", "type": VisualPortTypes.PortType.INT}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Result", "type": VisualPortTypes.PortType.INT}
	]
