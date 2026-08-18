@tool
extends GraphNode
class_name BaseVisualNode

@export var datos_nodo: VisualNodeData:
	set(valor):
		datos_nodo = valor
		if is_inside_tree():
			reconstruir_nodo()

@onready var fsm: VisualNodeStateMachine = $StateMachine


const COLORES_PUERTOS = {
	0: Color.WHITE,         
	1: Color.LIGHT_GREEN,    #
	2: Color.MEDIUM_AQUAMARINE, 
	3: Color.AQUA,          
	4: Color.ORANGE_RED,     
	5: Color.PURPLE         
}

func _ready() -> void:
	
	custom_minimum_size = Vector2(250, 120)
	
	
	resizable = true
	

	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	

	dragged.connect(_on_node_dragged)
	position_offset_changed.connect(_on_node_drag_ended)
	
	if datos_nodo:
		reconstruir_nodo()

func reconstruir_nodo() -> void:

	for hijo in get_children():
		if hijo != fsm:
			hijo.queue_free()
			
	if not datos_nodo:
		return
		
	title = datos_nodo.nombre_nodo
	

	var stylebox = get_theme_stylebox("panel")
	if stylebox is StyleBoxFlat:
		stylebox.bg_color = datos_nodo.color_titulo
	
	var total_filas = max(datos_nodo.entradas.size(), datos_nodo.salidas.size())
	
	
	for i in range(total_filas):
		var fila = HBoxContainer.new()
		fila.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var hay_izq = i < datos_nodo.entradas.size()
		var hay_der = i < datos_nodo.salidas.size()
		

		var tipo_izq = datos_nodo.entradas[i].tipo if hay_izq else 0
		var color_izq = COLORES_PUERTOS.get(tipo_izq, Color.WHITE)
		
		var tipo_der = datos_nodo.salidas[i].tipo if hay_der else 0
		var color_der = COLORES_PUERTOS.get(tipo_der, Color.WHITE)
		
		
		set_slot(i, hay_izq, tipo_izq, color_izq, hay_der, tipo_der, color_der)
		
		
		var label_izq = Label.new()
		label_izq.text = datos_nodo.entradas[i].nombre if hay_izq else ""
		fila.add_child(label_izq)
		
		
		var separador = Control.new()
		separador.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fila.add_child(separador)
		
		
		var label_der = Label.new()
		label_der.text = datos_nodo.salidas[i].nombre if hay_der else ""
		label_der.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		fila.add_child(label_der)
		
		add_child(fila)



func _on_node_dragged(_from: Vector2, _to: Vector2) -> void:
	if fsm and fsm.estado_actual != "Dragging":
		fsm.cambiar_a("Dragging")

func _on_node_drag_ended() -> void:

	if fsm:
		fsm.cambiar_a("Idle")
