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
			
	VisualNodeSlotRenderer.render_slots(self, input_ports, output_ports)
	VisualNodeWidgetInjector.inject_input_box(self, title)
		
	notify_property_list_changed()
	reset_size()

func get_custom_widget_value() -> String:
	if has_node("CustomValueInput"):
		var box = get_node("CustomValueInput") as LineEdit
		if box:
			return box.text
	return ""

func _on_node_focused() -> void:
	if fsm: fsm.change_to("Selected")

func _on_node_unfocused() -> void:
	if fsm: fsm.change_to("Idle")

func _on_node_dragged(_from: Vector2, _to: Vector2) -> void:
	if fsm and fsm.current_state != "Dragging": fsm.change_to("Dragging")

func _on_node_drag_ended() -> void:
	if fsm: fsm.change_to("Selected")
