@tool
extends RefCounted
class_name GraphSerializer

# Función para empaquetar el lienzo actual en un Diccionario plano de datos
static func guardar_grafico(graph_edit: GraphEdit) -> Dictionary:
	var datos_guardado = {
		"nodos": [],
		"conexiones": graph_edit.get_connection_list()
	}
	
	# Recorremos todos los elementos del lienzo buscando nuestros bloques visuales
	for hijo in graph_edit.get_children():
		if hijo is GraphNode and hijo.has_method("reconstruir_nodo"):
			var info_nodo = {
				"nombre": hijo.name,
				"posicion_x": hijo.position_offset.x,
				"posicion_y": hijo.position_offset.y,
				# Guardamos la ruta del recurso original para saber qué tipo de nodo era
				"recurso_path": hijo.datos_nodo.resource_path if hijo.datos_nodo else ""
			}
			datos_guardado["nodos"].append(info_nodo)
			
	return datos_guardado

# Función para reconstruir el lienzo a partir de un Diccionario plano de datos
static func cargar_grafico(graph_edit: GraphEdit, datos_guardado: Dictionary, escena_nodo: PackedScene) -> void:
	# 1. Limpieza absoluta del lienzo actual
	graph_edit.clear_connections()
	for hijo in graph_edit.get_children():
		if hijo is GraphNode and hijo.has_method("reconstruir_nodo"):
			hijo.queue_free()
			
	# Esperar a que el motor borre los nodos de la memoria antes de spawnear los nuevos
	await graph_edit.get_tree().process_frame
	
	# 2. Reconstruir los Nodos
	for info in datos_guardado.get("nodos", []):
		var nuevo_nodo = escena_nodo.instantiate()
		nuevo_nodo.name = info["nombre"]
		nuevo_nodo.position_offset = Vector2(info["posicion_x"], info["posicion_y"])
		
		# Si el nodo usaba un archivo de recursos, lo volvemos a cargar del disco
		if info["recurso_path"] != "":
			nuevo_nodo.datos_nodo = load(info["recurso_path"])
			
		graph_edit.add_child(nuevo_nodo)
		nuevo_nodo.reconstruir_nodo()
		
	# 3. Reconstruir los Cables (Conexiones)
	for con in datos_guardado.get("conexiones", []):
		graph_edit.connect_node(con["from_node"], con["from_port"], con["to_node"], con["to_port"])
