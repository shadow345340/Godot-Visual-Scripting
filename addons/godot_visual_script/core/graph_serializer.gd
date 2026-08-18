@tool
extends RefCounted
class_name GraphSerializer

static func serialize_graph(graph_edit: GraphEdit) -> Dictionary:
	var save_data = {
		"nodes": [],
		"connections": graph_edit.get_connection_list()
	}
	
	for child in graph_edit.get_children():
		if child is BaseVisualNode:
			var node_info = {
				"name": child.name,
				"position_x": child.position_offset.x,
				"position_y": child.position_offset.y,
				"class_definition": child.class_definition
			}
			save_data["nodes"].append(node_info)
			
	return save_data

static func deserialize_graph(graph_edit: GraphEdit, save_data: Dictionary, node_scene: PackedScene) -> void:
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is BaseVisualNode:
			child.queue_free()
			
	await graph_edit.get_tree().process_frame
	
	for info in save_data.get("nodes", []):
		var new_node = node_scene.instantiate()
		new_node.name = info["name"]
		new_node.position_offset = Vector2(info["position_x"], info["position_y"])
		
		if info["class_definition"] != "":
			var class_script = load(info["class_definition"])
			if class_script:
				var class_instance = class_script.new()
				graph_edit.add_child(new_node)
				new_node.initialize_with_class(class_instance)
		else:
			graph_edit.add_child(new_node)
		
	for con in save_data.get("connections", []):
		graph_edit.connect_node(con["from_node"], con["from_port"], con["to_node"], con["to_port"])
