@tool
extends Control

@onready var tab_bar: TabBar = $VBoxContainer/ScriptTabBar
@onready var graph_edit: GraphEdit = $VBoxContainer/GraphEdit

const BASE_NODE_SCENE = preload("res://addons/godot_visual_script/nodes/base_visual_node.tscn")
const SEARCH_MENU_SCENE = preload("res://addons/godot_visual_script/ui/search_menu.tscn")

const StyleScript = preload("res://addons/godot_visual_script/core/visual_node_style.gd")
const FactoryScript = preload("res://addons/godot_visual_script/core/visual_node_factory.gd")
const BridgeScript = preload("res://addons/godot_visual_script/core/visual_signal_bridge.gd")
const CatalogScript = preload("res://addons/godot_visual_script/core/visual_node_catalog.gd")
const ValidatorScript = preload("res://addons/godot_visual_script/core/visual_connection_validator.gd")

# Cambiamos de SearchMenu a PopupPanel para romper el conflicto de nombres
var search_menu: PopupPanel
var signal_bridge: RefCounted
var node_catalog: RefCounted

var open_tabs_memory: Dictionary = {}
var current_active_file: String = ""

func _ready() -> void:
	anchor_right = 1.0
	anchor_bottom = 1.0
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	if graph_edit:
		StyleScript.setup_canvas_theme(graph_edit)
		graph_edit.right_disconnects = true
		
		signal_bridge = BridgeScript.new(graph_edit, self)
		signal_bridge.call("connect_signals")
		
		node_catalog = CatalogScript.new()
		node_catalog.call("load_components")
		
		_create_toolbar_buttons()
		
	if tab_bar:
		if not tab_bar.tab_changed.is_connected(_on_tab_changed):
			tab_bar.tab_changed.connect(_on_tab_changed)
		if not tab_bar.tab_close_pressed.is_connected(_on_tab_close_pressed):
			tab_bar.tab_close_pressed.connect(_on_tab_close_pressed)
			
	_auto_scan_project_files()

func _create_toolbar_buttons() -> void:
	var menu_hbox = graph_edit.get_menu_hbox()
	if menu_hbox.has_node("NewScriptButton"): return
	
	var new_btn = Button.new()
	new_btn.name = "NewScriptButton"
	new_btn.text = "New Script (.gvs)"
	new_btn.pressed.connect(_on_new_script_pressed)
	menu_hbox.add_child(new_btn)
	
	var save_btn = Button.new()
	save_btn.name = "SaveScriptButton"
	save_btn.text = "Save Active Tab"
	save_btn.pressed.connect(_on_save_active_tab)
	menu_hbox.add_child(save_btn)

func _auto_scan_project_files() -> void:
	if not tab_bar: return
	var files = _find_gvs_in_directory("res://")
	
	for i in range(tab_bar.tab_count - 1, -1, -1):
		var path = tab_bar.get_tab_metadata(i)
		if typeof(path) != TYPE_STRING or not path in files:
			_close_tab_by_index(i)
			
	for file_path in files:
		var exists = false
		for i in range(tab_bar.tab_count):
			var current_meta = tab_bar.get_tab_metadata(i)
			if typeof(current_meta) == TYPE_STRING and current_meta == file_path:
				exists = true
				tab_bar.set_tab_title(i, file_path.get_file())
				break
		if not exists:
			tab_bar.add_tab(file_path.get_file())
			var new_idx = tab_bar.tab_count - 1
			tab_bar.set_tab_metadata(new_idx, file_path)

func _find_gvs_in_directory(path: String) -> Array[String]:
	var results: Array[String] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and not file_name.begins_with("."):
				results.append_array(_find_gvs_in_directory(path + file_name + "/"))
			elif file_name.ends_with(".gvs"):
				results.append(path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return results

func _on_new_script_pressed() -> void:
	var base_name = "player_movement"
	var counter = 1
	var path = "res://" + base_name + ".gvs"
	
	while FileAccess.file_exists(path):
		path = "res://" + base_name + "_" + str(counter) + ".gvs"
		counter += 1
		
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"nodes": [], "connections": []}))
		file.close()
		
	_auto_scan_project_files()
	EditorInterface.get_resource_filesystem().scan()

func _on_tab_changed(tab_index: int) -> void:
	if not graph_edit or not tab_bar or tab_index < 0 or tab_index >= tab_bar.tab_count:
		current_active_file = ""
		_clear_canvas_data()
		return
		
	if current_active_file != "":
		open_tabs_memory[current_active_file] = GraphSerializer.serialize_graph(graph_edit)
		
	var path_meta = tab_bar.get_tab_metadata(tab_index)
	if typeof(path_meta) != TYPE_STRING:
		current_active_file = ""
		_clear_canvas_data()
		return
		
	current_active_file = path_meta
	
	if open_tabs_memory.has(current_active_file):
		_load_data_into_canvas(open_tabs_memory[current_active_file])
	else:
		var file = FileAccess.open(current_active_file, FileAccess.READ)
		if file:
			var json = JSON.new()
			if json.parse(file.get_as_text()) == OK:
				_load_data_into_canvas(json.get_data())
			file.close()

func _on_tab_close_pressed(tab_index: int) -> void:
	if tab_index >= 0 and tab_index < tab_bar.tab_count:
		_close_tab_by_index(tab_index)

func _close_tab_by_index(index: int) -> void:
	if not tab_bar: return
	var path_meta = tab_bar.get_tab_metadata(index)
	if typeof(path_meta) == TYPE_STRING:
		open_tabs_memory.erase(path_meta)
		if current_active_file == path_meta:
			current_active_file = ""
			_clear_canvas_data()
	tab_bar.remove_tab(index)

func _on_save_active_tab() -> void:
	if current_active_file == "" or not graph_edit: return
	var data = GraphSerializer.serialize_graph(graph_edit)
	var file = FileAccess.open(current_active_file, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		open_tabs_memory[current_active_file] = data

func _load_data_into_canvas(data: Dictionary) -> void:
	_clear_canvas_data()
	await get_tree().process_frame
	if graph_edit and current_active_file != "":
		await GraphSerializer.deserialize_graph(graph_edit, data, BASE_NODE_SCENE)

func _clear_canvas_data() -> void:
	if not graph_edit: return
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode: child.queue_free()

func _ensure_search_menu_exists() -> void:
	if search_menu == null:
		search_menu = SEARCH_MENU_SCENE.instantiate()
		add_child(search_menu)
		search_menu.node_selected.connect(_on_node_created_from_menu)

func _on_canvas_right_click(screen_position: Vector2) -> void:
	if current_active_file == "" or not graph_edit: return
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
	if ValidatorScript.is_connection_valid(graph_edit, from_node, from_port, to_node, to_port):
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
func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.get("type") == "visual_script_node_class"

func _drop_data(pos: Vector2, data: Variant) -> void:
	var class_instance = data.get("data")
	var canvas_position = (pos + graph_edit.scroll_offset) / graph_edit.zoom
	FactoryScript.spawn_node(BASE_NODE_SCENE, class_instance, canvas_position, graph_edit)
