@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Apply Impulse"

func get_category() -> String:
	return "Physics"

func get_header_color() -> Color:
	return Color(0.45, 0.25, 0.1)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Exec", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "Target Path", "type": VisualPortTypes.PortType.STRING},
		{"name": "Force Vector", "type": VisualPortTypes.PortType.VECTOR}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Then", "type": VisualPortTypes.PortType.EXECUTION}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var path_string = inputs.get("Target Path", "")
	var impulse_force = inputs.get("Force Vector", Vector2.ZERO)
	
	if context and path_string != "":
		var target_node = context.get_node_or_null(NodePath(path_string))
		if target_node and target_node.has_method("apply_central_impulse"):
			target_node.call("apply_central_impulse", impulse_force)
			print("Physics Impulse Applied to: ", path_string)
			
	return {"Then": true}
