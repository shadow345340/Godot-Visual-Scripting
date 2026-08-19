@tool
extends Node
class_name VisualNodeStateMachine

signal state_changed(old_state: String, new_state: String)

var current_state: String = "Idle"
@onready var visual_node: GraphNode = get_parent()

func change_to(new_state: String) -> void:
	var old_state = current_state
	current_state = new_state
	
	if not visual_node:
		return
		
	match new_state:
		"Idle":
			visual_node.selected = false
		"Selected":
			visual_node.selected = true
		"Dragging":
			visual_node.selected = true
			
	state_changed.emit(old_state, new_state)
