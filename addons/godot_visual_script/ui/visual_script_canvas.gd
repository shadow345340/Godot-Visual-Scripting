@tool
extends Control

@onready var graph_edit: GraphEdit = $GraphEdit

const BASE_NODE_SCENE = preload("res://addons/godot_visual_script/nodes/base_visual_node.tscn")
const SEARCH_MENU_SCENE = preload("res://addons/godot_visual_script/ui/search_menu.tscn")

var search_menu: SearchMenu
var node_class_database: Array[Object] = []

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
		
		if graph_edit.connection_request.is_connected(_on_connection_request): graph_edit.connection_request.disconnect(_on_connection_request)
		if graph_edit.disconnection_request.is_connected(_on_disconnection_request): graph_edit.disconnection_request.disconnect(_on_disconnection_request)
		if graph_edit.delete_nodes_request.is_connected(_on_delete_nodes_request): graph_edit.delete_nodes_request.disconnect(_on_delete_nodes_request)
		if graph_edit.popup_request.is_connected(_on_canvas_right_click): graph_edit.popup_request.disconnect(_on_canvas_right_click)
		
		graph_edit.connection_request.connect(_on_connection_request)
		graph_edit.disconnection_request.connect(_on_disconnection_request)
		graph_edit.delete_nodes_request.connect(_on_delete_nodes_request)
		graph_edit.popup_request.connect(_on_canvas_right_click)
		
	mouse_filter = Control.MOUSE_FILTER_PASS
	_generate_hardcoded_classes()

func _ensure_search_menu_exists() -> void:
	if search_menu == null:
		search_menu = SEARCH_MENU_SCENE.instantiate()
		add_child(search_menu)
		search_menu.node_selected.connect(_on_node_created_from_menu)

func _on_canvas_right_click(screen_position: Vector2) -> void:
	_ensure_search_menu_exists()
	
	var canvas_position = (screen_position + graph_edit.scroll_offset) / graph_edit.zoom
	if search_menu:
		search_menu.canvas_click_position = canvas_position
		search_menu.initialize_catalog(node_class_database)
		
		var global_mouse = get_viewport().get_mouse_position()
		var final_position = Vector2(get_window().position) + global_mouse
		search_menu.position = Vector2i(final_position)
		search_menu.popup()

func _on_node_created_from_menu(class_instance: Object, position: Vector2) -> void:
	if not graph_edit:
		return
	var new_visual_node = BASE_NODE_SCENE.instantiate()
	new_visual_node.position_offset = position
	graph_edit.add_child(new_visual_node)
	new_visual_node.initialize_with_class(class_instance)

func _generate_hardcoded_classes() -> void:
	node_class_database.clear()
	
	var add_script = load("res://addons/godot_visual_script/nodes/components/node_class_add.gd")
	var if_script = load("res://addons/godot_visual_script/nodes/components/node_class_if.gd")
	
	if add_script:
		node_class_database.append(add_script.new())
	if if_script:
		node_class_database.append(if_script.new())

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
