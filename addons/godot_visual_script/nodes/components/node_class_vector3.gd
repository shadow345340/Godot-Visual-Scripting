@tool
extends NodeDefinition

func get_node_name() -> String: return "Vector3"
func get_category() -> String: return "Math"
func get_header_color() -> Color: return Color(0.3, 0.2, 0.5)
func get_inputs() -> Array[Dictionary]: return [
	{"name": "X", "type": VisualPortTypes.PortType.FLOAT},
	{"name": "Y", "type": VisualPortTypes.PortType.FLOAT},
	{"name": "Z", "type": VisualPortTypes.PortType.FLOAT}
]
func get_outputs() -> Array[Dictionary]: return [{"name": "Vector", "type": VisualPortTypes.PortType.VECTOR}]

func execute(inputs: Dictionary, _context: Node) -> Dictionary:
	var x = inputs.get("X", 0.0)
	var y = inputs.get("Y", 0.0)
	var z = inputs.get("Z", 0.0)
	return {"Vector": Vector3(x, y, z)}
