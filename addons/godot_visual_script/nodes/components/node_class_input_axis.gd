@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Input Axis"

func get_category() -> String:
	return "Events"

func get_header_color() -> Color:
	return Color(0.55, 0.35, 0.2)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Negative Action", "type": VisualPortTypes.PortType.STRING},
		{"name": "Positive Action", "type": VisualPortTypes.PortType.STRING}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Axis Value", "type": VisualPortTypes.PortType.FLOAT}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var neg = inputs.get("Negative Action", "ui_left")
	var pos = inputs.get("Positive Action", "ui_right")
	var axis = Input.get_axis(neg, pos)
	return {"Axis Value": axis}
