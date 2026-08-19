@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Print"

func get_category() -> String:
	return "Utility"

func get_header_color() -> Color:
	return Color(0.25, 0.25, 0.25)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "Exec", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "Message", "type": VisualPortTypes.PortType.STRING}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Then", "type": VisualPortTypes.PortType.EXECUTION}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var message = inputs.get("Message", "")
	print(str(message))
	return {"Then": true}
