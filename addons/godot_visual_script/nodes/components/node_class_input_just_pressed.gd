@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Input Just Pressed"

func get_category() -> String:
	return "Events"

func get_header_color() -> Color:
	return Color(0.55, 0.35, 0.2)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Action Name", "type": VisualPortTypes.PortType.STRING}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Just Pressed", "type": VisualPortTypes.PortType.BOOL}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var action = inputs.get("Action Name", "ui_accept")
	var triggered = Input.is_action_just_pressed(action)
	return {"Just Pressed": triggered}
