@tool
extends Object
class_name VisualConnectionValidator

static func is_connection_valid(graph_edit: GraphEdit, from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> bool:
	var source = graph_edit.get_node(NodePath(from_node)) as BaseVisualNode
	var target = graph_edit.get_node(NodePath(to_node)) as BaseVisualNode
	
	if not source or not target:
		return false
		
	var type_from = source.output_ports[from_port]["type"]
	var type_to = target.input_ports[to_port]["type"]
	
	return type_from == type_to
