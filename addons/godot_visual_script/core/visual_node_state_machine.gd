@tool
extends Node
class_name VisualNodeStateMachine

signal estado_cambiado(estado_antiguo: String, estado_nuevo: String)

var estado_actual: String = "Idle"
@onready var nodo_visual: GraphNode = get_parent()

func cambiar_a(nuevo_estado: String) -> void:
	var estado_antiguo = estado_actual
	estado_actual = nuevo_estado
	
	# Ejecutar la lógica según el estado en el que entra el nodo
	match nuevo_estado:
		"Idle":
			nodo_visual.modulate = Color.WHITE
		"Dragging":
			# Reducimos la opacidad un poco al arrastrar para dar feedback visual
			nodo_visual.modulate = Color(1, 1, 1, 0.7)
		"Executing":
			# Destello verde rápido de procesamiento
			nodo_visual.modulate = Color.GREEN_YELLOW
		"Error":
			# Alerta visual de error en la conexión o datos
			nodo_visual.modulate = Color.TOMATO
			
	estado_cambiado.emit(estado_antiguo, nuevo_estado)
