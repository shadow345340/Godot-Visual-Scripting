@tool
extends Control

@onready var graph_edit: GraphEdit = $GraphEdit

const BASE_NODE_SCENE = preload("res://addons/godot_visual_script/nodes/base_visual_node.tscn")
const SEARCH_MENU_SCENE = preload("res://addons/godot_visual_script/ui/search_menu.tscn")

# Precalentamos los scripts modulares para evitar errores de compilacion en el editor
const StyleScript = preload("res://addons/godot_visual_script/core/visual_node_style.gd")
const FactoryScript = preload("res://addons/godot_visual_script/core/visual_node_factory.gd")
const BridgeScript = preload("res://addons/godot_visual_script/core/visual_signal_bridge.gd")
const CatalogScript = preload("res://addons/godot_visual_script/core/visual_node_catalog.gd")

var search_menu: SearchMenu
var signal_bridge: RefCounted
var node_catalog: RefCounted

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	if graph_edit:
		StyleScript.setup_canvas_theme(graph_edit)
		
		signal_bridge = BridgeScript.new(graph_edit, self)
		signal_bridge.call("connect_signals")
		
		node_catalog = CatalogScript.new()
		node_catalog.call("load_components")

func _ensure_search_menu_exists() -> void:
	if search_menu == null:
		search_menu = SEARCH_MENU_SCENE.instantiate()
		add_child(search_menu)
		search_menu.node_selected.connect(_on_node_created_from_menu)

func _on_canvas_right_click(screen_position: Vector2) -> void:
	if not graph_edit: 
		return
	_ensure_search_menu_exists()
	
	var canvas_position = (screen_position + graph_edit.scroll_offset) / graph_edit.zoom
	search_menu.canvas_click_position = canvas_position
	search_menu.initialize_catalog(node_catalog.call("get_database"))
	
	var global_mouse = get_viewport().get_mouse_position()
	search_menu.position = Vector2i(Vector2(get_window().position) + global_mouse)
	search_menu.popup()

func _on_node_created_from_menu(class_instance: Object, position: Vector2) -> void:
	FactoryScript.spawn_node(BASE_NODE_SCENE, class_instance, position, graph_edit)

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func _on_delete_nodes_request(nodes_to_delete: Array[StringName]) -> void:
	for node_name in nodes_to_delete:
		var node = graph_edit.get_node(NodePath(node_name))
		if node:
			for connection in graph_edit.get_connection_list():
				if connection["from_node"] == node_name or connection["to_node"] == node_name:
					graph_edit.disconnect_node(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"])
			node.queue_free()
