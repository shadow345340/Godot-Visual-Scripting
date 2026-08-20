@tool
extends RefCounted
class_name GraphSerializer

static func serialize_graph(graph_edit: GraphEdit) -> Dictionary:
	var save_data = {
		"nodes": [],
		"connections": graph_edit.get_connection_list()
	}
	
	for child in graph_edit.get_children():
		if child is GraphNode and "class_definition" in child:
			var node_info = {
				"name": child.name,
				"position_x": child.position_offset.x,
				"position_y": child.position_offset.y,
				"class_definition": child.class_definition,
				"custom_value": child.call("get_custom_widget_value") if child.has_method("get_custom_widget_value") else ""
			}
			save_data["nodes"].append(node_info)
			
	return save_data

static func deserialize_graph(graph_edit: GraphEdit, save_data: Dictionary, node_scene: PackedScene) -> void:
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode:
			child.queue_free()
			
	await graph_edit.get_tree().process_frame
	
	for info in save_data.get("nodes", []):
		var class_path = info.get("class_definition", "")
		if class_path != "":
			var class_script = load(class_path)
			if class_script:
				var class_instance = class_script.new()
				var pos = Vector2(info["position_x"], info["position_y"])
				
				VisualNodeFactory.spawn_node(node_scene, class_instance, pos, graph_edit)
				
				# CORRECCIÓN VITAL: Esperamos un frame a que Godot asigne la ruta fisica real del nodo
				await graph_edit.get_tree().process_frame
				
				# Buscamos el nodo usando el ultimo hijo añadido en lugar de su string de nombre volatil
				if graph_edit.get_child_count() > 0:
					var created_node = graph_edit.get_child(graph_edit.get_child_count() - 1) as GraphNode
					if created_node and created_node.has_node("CustomValueInput"):
						var box = created_node.get_node("CustomValueInput") as LineEdit
						if box:
							box.text = info.get("custom_value", "")
						
	for con in save_data.get("connections", []):
		graph_edit.connect_node(con["from_node"], con["from_port"], con["to_node"], con["to_port"])
