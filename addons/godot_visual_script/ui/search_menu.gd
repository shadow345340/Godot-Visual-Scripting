@tool
extends PopupPanel

signal node_selected(class_instance: Object, canvas_mouse_position: Vector2)

@onready var search_box: LineEdit = $VBoxContainer/Buscador
@onready var node_tree: Tree = $VBoxContainer/NodeTree

var complete_catalog: Array[Object] = []
var filtered_catalog: Array[Object] = []
var canvas_click_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	size = Vector2i(280, 400)
	
	if not search_box.text_changed.is_connected(_on_search_text_changed):
		search_box.text_changed.connect(_on_search_text_changed)
	if not node_tree.item_selected.is_connected(_on_tree_item_selected):
		node_tree.item_selected.connect(_on_tree_item_selected)
	if not about_to_popup.is_connected(_on_about_to_popup):
		about_to_popup.connect(_on_about_to_popup)

func _on_about_to_popup() -> void:
	search_box.text = ""
	filter_catalog("")
	await get_tree().process_frame
	if search_box: 
		search_box.grab_focus()

func initialize_catalog(new_classes: Array[Object]) -> void:
	complete_catalog = new_classes
	filter_catalog("")

func _on_search_text_changed(new_text: String) -> void:
	filter_catalog(new_text)

func filter_catalog(filter: String) -> void:
	if not is_inside_tree() or node_tree == null: 
		return
		
	node_tree.clear()
	var root = node_tree.create_item()
	var filter_min = filter.to_lower().strip_edges()
	var categories: Dictionary = {}
	
	for node in complete_catalog:
		if node == null: 
			continue
		var name_min = node.get_node_name().to_lower()
		var cat_min = node.get_category().to_lower()
		
		if filter_min == "" or filter_min in name_min or filter_min in cat_min:
			var cat_name = node.get_category()
			if not categories.has(cat_name):
				var cat_item = node_tree.create_item(root)
				cat_item.set_text(0, cat_name)
				cat_item.set_selectable(0, false)
				categories[cat_name] = cat_item
				
			var parent_category = categories[cat_name]
			var node_item = node_tree.create_item(parent_category)
			node_item.set_text(0, node.get_node_name())
			node_item.set_metadata(0, node)
			node_item.set_custom_color(0, node.get_header_color().lightened(0.4))

func _on_tree_item_selected() -> void:
	var selected_item = node_tree.get_selected()
	if selected_item == null: 
		return
		
	var node_data = selected_item.get_metadata(0)
	if node_data != null:
		node_selected.emit(node_data, canvas_click_position)
		hide()
