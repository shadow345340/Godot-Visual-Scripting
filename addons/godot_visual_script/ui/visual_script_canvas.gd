@tool
extends Control

@onready var graph_edit: GraphEdit = $GraphEdit

const BASE_NODE_ESCENA = preload("res://addons/godot_visual_script/nodes/base_visual_node.tscn")
const SEARCH_MENU_ESCENA = preload("res://addons/godot_visual_script/ui/search_menu.tscn")
const RUTA_GUARDADO = "res://visual_script_save.json"

var menu_busqueda: SearchMenu
var base_datos_nodos: Array[VisualNodeData] = []

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	if graph_edit:
		graph_edit.anchor_right = 1.0
		graph_edit.anchor_bottom = 1.0
		graph_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		graph_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
		graph_edit.mouse_filter = Control.MOUSE_FILTER_STOP
		graph_edit.set("theme_override_colors/grid_major", Color(1, 1, 1, 0.12))
		graph_edit.set("theme_override_colors/grid_minor", Color(1, 1, 1, 0.04))
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Desconexión preventiva de señales viejas
	if graph_edit.connection_request.is_connected(_on_connection_request): graph_edit.connection_request.disconnect(_on_connection_request)
	if graph_edit.disconnection_request.is_connected(_on_disconnection_request): graph_edit.disconnection_request.disconnect(_on_disconnection_request)
	if graph_edit.delete_nodes_request.is_connected(_on_delete_nodes_request): graph_edit.delete_nodes_request.disconnect(_on_delete_nodes_request)
	if graph_edit.popup_request.is_connected(_on_canvas_right_click): graph_edit.popup_request.disconnect(_on_canvas_right_click)
		
	graph_edit.connection_request.connect(_on_connection_request)
	graph_edit.disconnection_request.connect(_on_disconnection_request)
	graph_edit.delete_nodes_request.connect(_on_delete_nodes_request)
	graph_edit.popup_request.connect(_on_canvas_right_click)
	
	_crear_barra_herramientas()

func _crear_barra_herramientas() -> void:
	var menu_hbox = graph_edit.get_menu_hbox()
	if menu_hbox.has_node("BotonGuardar"): return
	
	var btn_guardar = Button.new()
	btn_guardar.name = "BotonGuardar"
	btn_guardar.text = "💾 Guardar Script"
	btn_guardar.pressed.connect(_on_boton_guardar_pulsado)
	menu_hbox.add_child(btn_guardar)
	
	var btn_cargar = Button.new()
	btn_cargar.name = "BotonCargar"
	btn_cargar.text = "📂 Cargar Script"
	btn_cargar.pressed.connect(_on_boton_cargar_pulsado)
	menu_hbox.add_child(btn_cargar)

func _asegurar_menu_creado() -> void:
	if menu_busqueda == null:
		menu_busqueda = SEARCH_MENU_ESCENA.instantiate()
		add_child(menu_busqueda)
		menu_busqueda.nodo_seleccionado.connect(_on_nodo_creado_desde_menu)

func _on_canvas_right_click(posicion_pantalla: Vector2) -> void:
	_asegurar_menu_creado()
	_generar_nodos_de_prueba()
	
	var posicion_lienzo = (posicion_pantalla + graph_edit.scroll_offset) / graph_edit.zoom
	if menu_busqueda:
		menu_busqueda.posicion_click_lienzo = posicion_lienzo
	
	var mouse_global = get_viewport().get_mouse_position()
	var posicion_final = Vector2(get_window().position) + mouse_global
	
	if menu_busqueda:
		menu_busqueda.position = Vector2i(posicion_final)
		menu_busqueda.popup()

func _on_nodo_creado_desde_menu(datos: VisualNodeData, posicion: Vector2) -> void:
	var nuevo_nodo_visual = BASE_NODE_ESCENA.instantiate()
	nuevo_nodo_visual.datos_nodo = datos
	nuevo_nodo_visual.position_offset = posicion
	graph_edit.add_child(nuevo_nodo_visual)
	
	if nuevo_nodo_visual.has_method("reconstruir_nodo"):
		nuevo_nodo_visual.reconstruir_nodo()


func _generar_nodos_de_prueba() -> void:
	base_datos_nodos.clear()
	

	var in_suma: Array[Dictionary] = []
	in_suma.append({"nombre": "A", "tipo": 1})
	in_suma.append({"nombre": "B", "tipo": 1})
	
	var out_suma: Array[Dictionary] = []
	out_suma.append({"nombre": "Resultado", "tipo": 1})
	
	var suma = VisualNodeData.new()
	suma.nombre_nodo = "Sumar Valores"
	suma.categoria = "Matematicas"
	suma.color_titulo = Color(0.15, 0.4, 0.2)
	suma.entradas = in_suma
	suma.salidas = out_suma
	
	var in_if: Array[Dictionary] = []
	in_if.append({"nombre": "Ejecutar", "tipo": 0})
	in_if.append({"nombre": "Condicion", "tipo": 4})
	
	var out_if: Array[Dictionary] = []
	out_if.append({"nombre": "Verdadero", "tipo": 0})
	out_if.append({"nombre": "Falso", "tipo": 0})
	
	var condicion = VisualNodeData.new()
	condicion.nombre_nodo = "Rama (If)"
	condicion.categoria = "Flujo"
	condicion.color_titulo = Color(0.5, 0.15, 0.15)
	condicion.entradas = in_if
	condicion.salidas = out_if
	
	base_datos_nodos.append(suma)
	base_datos_nodos.append(condicion)
	
	if menu_busqueda != null:
		menu_busqueda.inicializar_catalogo(base_datos_nodos)

func _on_boton_guardar_pulsado() -> void:
	var datos = GraphSerializer.guardar_grafico(graph_edit)
	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
	if archivo:
		archivo.store_string(JSON.stringify(datos, "\t"))
		archivo.close()
		print("¡Visual Script guardado con éxito!")

func _on_boton_cargar_pulsado() -> void:
	if not FileAccess.file_exists(RUTA_GUARDADO):
		return
	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
	if archivo:
		var texto = archivo.get_as_text()
		archivo.close()
		var json = JSON.new()
		if json.parse(texto) == OK:
			var datos = json.get_data()
			await GraphSerializer.cargar_grafico(graph_edit, datos, BASE_NODE_ESCENA)
			print("¡Visual Script cargado con éxito!")

func _on_delete_nodes_request(nodos_a_borrar: Array[StringName]) -> void:
	for nombre_nodo in nodos_a_borrar:
		var nodo = graph_edit.get_node(NodePath(nombre_nodo))
		if nodo:
			for conexion in graph_edit.get_connection_list():
				if conexion["from_node"] == nombre_nodo or conexion["to_node"] == nombre_nodo:
					graph_edit.disconnect_node(conexion["from_node"], conexion["from_port"], conexion["to_node"], conexion["to_port"])
			nodo.queue_free()

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
