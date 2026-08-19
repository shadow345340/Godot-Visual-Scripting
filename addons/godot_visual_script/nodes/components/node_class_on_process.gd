@tool
extends NodeDefinition

func get_node_name() -> String:
	return "On Process"

func get_category() -> String:
	return "Events"

func get_header_color() -> Color:
	return Color(0.55, 0.4, 0.1)

func get_inputs() -> Array[Dictionary]:
	return []

func get_outputs() -> Array[Dictionary]:
	return [
		{"name": "Tick", "type": VisualPortTypes.PortType.EXECUTION},
		{"name": "Delta", "type": VisualPortTypes.PortType.FLOAT}
	]

func execute(inputs: Dictionary, context: Node) -> Dictionary:
	var delta_time = 0.0
	if context and context.has_meta("current_delta_time"):
		delta_time = context.get_meta("current_delta_time")
	return {
		"Tick": true,
		"Delta": delta_time
	}
