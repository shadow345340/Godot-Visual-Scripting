@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Apply Gravity"

func get_category() -> String:
	return "Movement"

func get_header_color() -> Color:
	return Color(0.25, 0.4, 0.55)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Velocity Y", "type": VisualPortTypes.PortType.FLOAT},
		{"name": "Delta", "type": VisualPortTypes.PortType.FLOAT},
		{"name": "Gravity Force", "type": VisualPortTypes.PortType.FLOAT}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "New Velocity Y", "type": VisualPortTypes.PortType.FLOAT}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var vel_y = inputs.get("Velocity Y", 0.0)
	var delta = inputs.get("Delta", 0.0)
	var gravity_force = inputs.get("Gravity Force", 0.0)
	
	if gravity_force == 0.0:
		gravity_force = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0)
		
	if context and context.has_method("is_on_floor") and context.call("is_on_floor"):
		vel_y = 0.0
	else:
		vel_y += gravity_force * delta
		
	return {"New Velocity Y": vel_y}
