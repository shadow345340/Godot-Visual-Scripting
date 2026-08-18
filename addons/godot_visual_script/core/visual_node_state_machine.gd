@tool
extends Node
class_name VisualNodeStateMachine

signal estado_cambiado(estado_antiguo: String, estado_nuevo: String)

var estado_actual: String = "Idle"
@onready var nodo_visual: GraphNode = get_parent()

func cambiar_a(nuevo_estado: String) -> void:
	var estado_antiguo = estado_actual
	estado_actual = nuevo_estado
	

	match nuevo_estado:
		"Idle":
			nodo_visual.modulate = Color.WHITE
		"Dragging":
			
			nodo_visual.modulate = Color(1, 1, 1, 0.7)
		"Executing":
			
			nodo_visual.modulate = Color.GREEN_YELLOW
		"Error":
			
			nodo_visual.modulate = Color.TOMATO
			
	estado_cambiado.emit(estado_antiguo, nuevo_estado)
