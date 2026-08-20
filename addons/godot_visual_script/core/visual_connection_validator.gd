@tool
extends Object
class_name VisualConnectionValidator

static func is_connection_valid(graph_edit: GraphEdit, from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> bool:
	var source = graph_edit.get_node(NodePath(from_node))
	var target = graph_edit.get_node(NodePath(to_node))
	
	if not source or not target:
		return false
		
	var source_outputs = source.get("output_ports") if "output_ports" in source else []
	var target_inputs = target.get("input_ports") if "input_ports" in target else []
	
	if from_port >= source_outputs.size() or to_port >= target_inputs.size():
		return false
		
	var type_from = source_outputs[from_port].get("type", 0)
	var type_to = target_inputs[to_port].get("type", 0)
	
	return type_from == type_to
