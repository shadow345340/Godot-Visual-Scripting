@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Input Vector X"

func get_category() -> String:
	return "Events"

func get_header_color() -> Color:
	return Color(0.55, 0.35, 0.2)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Speed", "type": VisualPortTypes.PortType.FLOAT}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Direction X", "type": VisualPortTypes.PortType.FLOAT}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var speed = inputs.get("Speed", 300.0)
	var direction = Input.get_axis("ui_left", "ui_right")
	return {"Direction X": direction * speed}
