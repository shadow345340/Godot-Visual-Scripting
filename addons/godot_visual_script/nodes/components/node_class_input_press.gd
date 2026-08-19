@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Input Press"

func get_category() -> String:
	return "Events"

func get_header_color() -> Color:
	return Color(0.55, 0.35, 0.15)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Action Name", "type": VisualPortTypes.PortType.STRING}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Is Pressed", "type": VisualPortTypes.PortType.BOOL}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var action = inputs.get("Action Name", "")
	var pressed = false
	
	if action != "":
		pressed = Input.is_action_pressed(action)
		
	return {"Is Pressed": pressed}
