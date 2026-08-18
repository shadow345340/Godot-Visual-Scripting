@tool
extends Object
class_name VisualPortTypes

enum PortType {
	EXECUTION = 0,
	INT = 1,
	FLOAT = 2,
	STRING = 3,
	BOOL = 4,
	VECTOR = 5
}

static func get_port_color(type: PortType) -> Color:
	match type:
		PortType.EXECUTION: return Color.WHITE
		PortType.INT: return Color.LIGHT_GREEN
		PortType.FLOAT: return Color.MEDIUM_AQUAMARINE
		PortType.STRING: return Color.AQUA
		PortType.BOOL: return Color.ORANGE_RED
		PortType.VECTOR: return Color.PURPLE
	return Color.GRAY
