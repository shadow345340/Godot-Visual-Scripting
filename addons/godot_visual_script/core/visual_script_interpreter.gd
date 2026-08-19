@tool
extends RefCounted
class_name VisualScriptInterpreter

var nodes_data: Array = []
var connections_data: Array = []
var instantiated_classes: Dictionary = {}
var computed_outputs: Dictionary = {}
var raw_nodes_map: Dictionary = {}

func _init(graph_data: Dictionary) -> void:
	nodes_data = graph_data.get("nodes", [])
	connections_data = graph_data.get("connections", [])
	
	for node_info in nodes_data:
		var node_name = node_info.get("name", "")
		if node_name != "":
			raw_nodes_map[node_name] = node_info
			
	_instance_node_classes()

func _instance_node_classes() -> void:
	instantiated_classes.clear()
	for node_info in nodes_data:
		var node_name = node_info.get("name", "")
		var script_path = node_info.get("class_definition", "")
		if node_name != "" and script_path != "":
			var script_ref = load(script_path)
			if script_ref:
				instantiated_classes[node_name] = script_ref.new()

func run_script(start_node_name: String, context_node: Node) -> void:
	computed_outputs.clear()
	var current_node = start_node_name
	
	while current_node != "":
		var current_class = instantiated_classes.get(current_node)
		if not current_class:
			break
			
		var gathered_inputs = _gather_inputs_for_node(current_node, context_node)
		var outputs = current_class.call("execute", gathered_inputs, context_node)
		computed_outputs[current_node] = outputs
		
		current_node = _get_next_execution_node(current_node, outputs)

func _gather_inputs_for_node(node_name: String, context_node: Node) -> Dictionary:
	var inputs = {}
	
	var node_info = raw_nodes_map.get(node_name, {})
	var custom_val = node_info.get("custom_value", "")
	
	if context_node:
		context_node.set_meta("text_input_value", custom_val)
		context_node.set_meta("int_input_value", int(custom_val))
		context_node.set_meta("float_input_value", float(custom_val))
		
	for con in connections_data:
		if con.get("to_node") == node_name:
			var from_node = con.get("from_node")
			var from_port = con.get("from_port", 0)
			var to_port = con.get("to_port", 0)
			
			var target_class = instantiated_classes.get(node_name)
			if target_class:
				var input_ports_def = target_class.call("get_inputs")
				if to_port < input_ports_def.size():
					var input_name = input_ports_def[to_port]["name"]
					var value = _get_output_value(from_node, from_port, context_node)
					inputs[input_name] = value
	return inputs

func _get_output_value(node_name: String, port_index: int, context_node: Node) -> Variant:
	if not computed_outputs.has(node_name):
		var current_class = instantiated_classes.get(node_name)
		if current_class:
			var gathered_inputs = _gather_inputs_for_node(node_name, context_node)
			var outputs = current_class.call("execute", gathered_inputs, context_node)
			computed_outputs[node_name] = outputs
			
	var node_outputs = computed_outputs.get(node_name, {})
	var current_class = instantiated_classes.get(node_name)
	if current_class:
		var outputs_def = current_class.call("get_outputs")
		if port_index < outputs_def.size():
			var output_name = outputs_def[port_index]["name"]
			return node_outputs.get(output_name, null)
	return null

func _get_next_execution_node(node_name: String, execution_outputs: Dictionary) -> String:
	var current_class = instantiated_classes.get(node_name)
	if not current_class:
		return ""
		
	var outputs_def = current_class.call("get_outputs")
	for i in range(outputs_def.size()):
		if outputs_def[i]["type"] == VisualPortTypes.PortType.EXECUTION:
			var out_name = outputs_def[i]["name"]
			var was_triggered = execution_outputs.get(out_name, false)
			
			if was_triggered or outputs_def.size() == 1:
				for con in connections_data:
					if con.get("from_node") == node_name and con.get("from_port") == i:
						return con.get("to_node", "")
	return ""
