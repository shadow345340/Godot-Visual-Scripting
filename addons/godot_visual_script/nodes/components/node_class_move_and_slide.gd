@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Move and Slide"

func get_category() -> String:
	return "Movement"

func get_header_color() -> Color:
	return Color(0.1, 0.5, 0.7)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Exec", "type": VisualPortTypes.PortType.EXECUTION}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Then", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "Is On Floor", "type": VisualPortTypes.PortType.BOOL}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var on_floor = false
	if context and context.has_method("move_and_slide"):
		context.call("move_and_slide")
		if context.has_method("is_on_floor"):
			on_floor = context.call("is_on_floor")
	return {"Then": true, "Is On Floor": on_floor}
