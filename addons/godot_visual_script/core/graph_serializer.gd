@tool
extends RefCounted
class_name GraphSerializer


static func guardar_grafico(graph_edit: GraphEdit) -> Dictionary:
	var datos_guardado = {
		"nodos": [],
		"conexiones": graph_edit.get_connection_list()
	}
	

	for hijo in graph_edit.get_children():
		if hijo is GraphNode and hijo.has_method("reconstruir_nodo"):
			var info_nodo = {
				"nombre": hijo.name,
				"posicion_x": hijo.position_offset.x,
				"posicion_y": hijo.position_offset.y,
			
				"recurso_path": hijo.datos_nodo.resource_path if hijo.datos_nodo else ""
			}
			datos_guardado["nodos"].append(info_nodo)
			
	return datos_guardado


static func cargar_grafico(graph_edit: GraphEdit, datos_guardado: Dictionary, escena_nodo: PackedScene) -> void:
	# 1. Limpieza absoluta del lienzo actual
	graph_edit.clear_connections()
	for hijo in graph_edit.get_children():
		if hijo is GraphNode and hijo.has_method("reconstruir_nodo"):
			hijo.queue_free()
			

	await graph_edit.get_tree().process_frame
	

	for info in datos_guardado.get("nodos", []):
		var nuevo_nodo = escena_nodo.instantiate()
		nuevo_nodo.name = info["nombre"]
		nuevo_nodo.position_offset = Vector2(info["posicion_x"], info["posicion_y"])
		

		if info["recurso_path"] != "":
			nuevo_nodo.datos_nodo = load(info["recurso_path"])
			
		graph_edit.add_child(nuevo_nodo)
		nuevo_nodo.reconstruir_nodo()
		
	
	for con in datos_guardado.get("conexiones", []):
		graph_edit.connect_node(con["from_node"], con["from_port"], con["to_node"], con["to_port"])
