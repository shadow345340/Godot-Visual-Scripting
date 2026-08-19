@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Get Velocity"

func get_category() -> String:
	return "Movement"

func get_header_color() -> Color:
	return Color(0.2, 0.4, 0.6)

func get_inputs() -> Array[Dictionary]:
	return []

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Velocity X", "type": VisualPortTypes.PortType.FLOAT},
		{"name": "Velocity Y", "type": VisualPortTypes.PortType.FLOAT}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var vel_x = 0.0
	var vel_y = 0.0
	if context and "velocity" in context:
		vel_x = context.velocity.x
		vel_y = context.velocity.y
	return {"Velocity X": vel_x, "Velocity Y": vel_y}
