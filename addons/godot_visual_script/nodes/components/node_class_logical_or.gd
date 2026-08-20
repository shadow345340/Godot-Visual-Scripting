@tool
extends NodeDefinition

func get_node_name() -> String:
	return "Or (||)"

func get_category() -> String:
	return "Conditionals"

func get_header_color() -> Color:
	return Color(0.45, 0.1, 0.2)

func get_inputs() -> Array[Dictionary]:
	return [
		{"name": "A", "type": VisualPortTypes.PortType.BOOL},
		{"name": "B", "type": VisualPortTypes.PortType.BOOL}
	]

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Result", "type": VisualPortTypes.PortType.BOOL}
	]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var a = inputs.get("A", false)
	var b = inputs.get("B", false)
	return {"Result": a or b}
