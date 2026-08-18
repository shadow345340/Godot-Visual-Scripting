@tool
extends PopupPanel
class_name SearchMenu

signal node_selected(class_instance: Object, canvas_mouse_position: Vector2)

@onready var search_box: LineEdit = $VBoxContainer/Buscador
@onready var node_list: ItemList = $VBoxContainer/ListaNodos

var complete_catalog: Array[Object] = []
var filtered_catalog: Array[Object] = []
var canvas_click_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	size = Vector2i(280, 350)
	
	if not search_box.text_changed.is_connected(_on_search_text_changed):
		search_box.text_changed.connect(_on_search_text_changed)
	if not node_list.item_activated.is_connected(_on_node_double_clicked):
		node_list.item_activated.connect(_on_node_double_clicked)
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
	if not is_inside_tree() or node_list == null:
		return
		
	node_list.clear()
	filtered_catalog.clear()
	
	var filter_min = filter.to_lower().strip_edges()
	
	for node in complete_catalog:
		if node == null:
			continue
			
		var name_min = node.get_node_name().to_lower()
		var cat_min = node.get_category().to_lower()
		
		if filter_min == "" or filter_min in name_min or filter_min in cat_min:
			filtered_catalog.append(node)
			var display_text = "[%s] %s" % [node.get_category(), node.get_node_name()]
			var index = node_list.add_item(display_text)
			node_list.set_item_custom_fg_color(index, node.get_header_color().lightened(0.5))
			
	if node_list.item_count == 0:
		node_list.add_item("No nodes found...")

func _on_node_double_clicked(index: int) -> void:
	if index >= 0 and index < filtered_catalog.size():
		node_selected.emit(filtered_catalog[index], canvas_click_position)
		hide()
