@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Set Velocity"

func get_category() -> String:
	return "Movement"

func get_header_color() -> Color:
	return Color(0.2, 0.45, 0.65)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Exec", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "Velocity X", "type": VisualPortTypes.PortType.FLOAT},
		{"name": "Velocity Y", "type": VisualPortTypes.PortType.FLOAT}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Then", "type": VisualPortTypes.PortType.EXECUTION}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var vel_x = inputs.get("Velocity X", 0.0)
	var vel_y = inputs.get("Velocity Y", 0.0)
	
	if context and "velocity" in context:
		context.velocity = Vector2(vel_x, vel_y)
		
	return {"Then": true}
