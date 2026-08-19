@tool
extends Object
class_name VisualNodeSlotRenderer

static func render_slots(node: GraphNode, inputs: Array[Dictionary], outputs: Array[Dictionary]) -> void:
	var total_rows = max(inputs.size(), outputs.size())
	
	for i in range(total_rows):
		var row = HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var has_left = i < inputs.size()
		var has_right = i < outputs.size()
		
		var type_left = inputs[i]["type"] if has_left else 0
		var color_left = VisualPortTypes.get_port_color(type_left)
		
		var type_right = outputs[i]["type"] if has_right else 0
		var color_right = VisualPortTypes.get_port_color(type_right)
		
		node.set_slot(i, has_left, type_left, color_left, has_right, type_right, color_right)
		
		var label_left = Label.new()
		label_left.text = inputs[i]["name"] if has_left else ""
		row.add_child(label_left)
		
		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(spacer)
		
		var label_right = Label.new()
		label_right.text = outputs[i]["name"] if has_right else ""
		label_right.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		row.add_child(label_right)
		
		node.add_child(row)
