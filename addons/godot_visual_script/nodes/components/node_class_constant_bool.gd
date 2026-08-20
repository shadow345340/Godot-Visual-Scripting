@tool
extends NodeDefinition

func get_node_name() -> String: return "Constant Bool"
func get_category() -> String: return "Constants"
func get_header_color() -> Color: return Color(0.1, 0.4, 0.45)
func get_inputs() -> Array[Dictionary]: return []
func get_outputs() -> Array[Dictionary]: return [{"name": "Value", "type": VisualPortTypes.PortType.BOOL}]

func inject_custom_widget(node: GraphNode) -> void:
	var check = CheckButton.new()
	check.text = "True/False"
	check.name = "CustomValueInput"
	node.add_child(check)

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var val = false
	if context and context.has_meta("text_input_value"):
		val = context.get_meta("text_input_value") == "1"
	return {"Value": val}
