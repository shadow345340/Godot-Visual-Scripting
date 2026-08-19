@tool
extends Object
class_name VisualNodeWidgetInjector

static func inject_input_box(node: GraphNode, title_text: String) -> void:
	if title_text in ["Text Value", "Whole Number", "Decimal Number"]:
		var input_box = LineEdit.new()
		input_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		input_box.placeholder_text = "Enter value..."
		input_box.name = "CustomValueInput"
		node.add_child(input_box)
