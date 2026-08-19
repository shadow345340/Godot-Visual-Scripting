@tool
extends GraphNode
class_name BaseVisualNode

@onready var fsm: VisualNodeStateMachine = $StateMachine

var class_definition: String = ""
var input_ports: Array[Dictionary] = []
var output_ports: Array[Dictionary] = []

func _ready() -> void:
	custom_minimum_size = Vector2(250, 120)
	resizable = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	if not dragged.is_connected(_on_node_dragged): dragged.connect(_on_node_dragged)
	if not position_offset_changed.is_connected(_on_node_drag_ended): position_offset_changed.connect(_on_node_drag_ended)
	if not node_selected.is_connected(_on_node_focused): node_selected.connect(_on_node_focused)
	if not node_deselected.is_connected(_on_node_unfocused): node_deselected.connect(_on_node_unfocused)
	
	# Aplicamos la copia aislada de estilos una sola vez al nacer
	VisualNodeStyle.apply_isolated_node_color(self)

func initialize_with_class(node_class: Object) -> void:
	class_definition = node_class.get_script().resource_path
	title = node_class.get_node_name()
	input_ports = node_class.get_inputs()
	output_ports = node_class.get_outputs()
	reconstruct_node()

func reconstruct_node() -> void:
	for child in get_children():
		if child != fsm: child.queue_free()
			
	var total_rows = max(input_ports.size(), output_ports.size())
	
	for i in range(total_rows):
		var row = HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var has_left = i < input_ports.size()
		var has_right = i < output_ports.size()
		
		var type_left = input_ports[i]["type"] if has_left else 0
		var color_left = VisualPortTypes.get_port_color(type_left)
		var type_right = output_ports[i]["type"] if has_right else 0
		var color_right = VisualPortTypes.get_port_color(type_right)
		
		set_slot(i, has_left, type_left, color_left, has_right, type_right, color_right)
		
		var label_left = Label.new()
		label_left.text = input_ports[i]["name"] if has_left else ""
		row.add_child(label_left)
		
		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(spacer)
		
		var label_right = Label.new()
		label_right.text = output_ports[i]["name"] if has_right else ""
		label_right.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		row.add_child(label_right)
		
		add_child(row)
		
	notify_property_list_changed()
	reset_size()

func _on_node_focused() -> void:
	if fsm: fsm.change_to("Selected")

func _on_node_unfocused() -> void:
	if fsm: fsm.change_to("Idle")

func _on_node_dragged(_from: Vector2, _to: Vector2) -> void:
	if fsm and fsm.current_state != "Dragging": fsm.change_to("Dragging")

func _on_node_drag_ended() -> void:
	if fsm: fsm.change_to("Selected")
