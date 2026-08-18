@tool
extends GraphNode
class_name BaseVisualNode

@export var datos_nodo: VisualNodeData:
	set(valor):
		datos_nodo = valor
		if is_inside_tree():
			reconstruir_nodo()

@onready var fsm: VisualNodeStateMachine = $StateMachine

# Diccionario de colores oficiales para diferenciar tipos de datos como en Unreal/Blender
const COLORES_PUERTOS = {
	0: Color.WHITE,         # EJECUCION (Blanco como cables de flujo)
	1: Color.LIGHT_GREEN,    # ENTERO
	2: Color.MEDIUM_AQUAMARINE, # FLOTANTE
	3: Color.AQUA,          # STRING / TEXTO
	4: Color.ORANGE_RED,     # BOOLEANO
	5: Color.PURPLE         # VECTOR
}

func _ready() -> void:
	# Forzar el tamaño mínimo para que nunca se colapse
	custom_minimum_size = Vector2(250, 120)
	
	# Permitir que el usuario pueda estirar el nodo con el ratón
	resizable = true
	
	# Indicar que los contenedores hijos deben expandirse
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	# Conectar señales nativas de movimiento a nuestra Máquina de Estados
	dragged.connect(_on_node_dragged)
	position_offset_changed.connect(_on_node_drag_ended)
	
	if datos_nodo:
		reconstruir_nodo()

func reconstruir_nodo() -> void:
	# 1. Limpiar la interfaz previa de forma segura
	for hijo in get_children():
		if hijo != fsm:
			hijo.queue_free()
			
	if not datos_nodo:
		return
		
	title = datos_nodo.nombre_nodo
	
	# Aplicar el color de cabecera personalizado desde el Resource
	var stylebox = get_theme_stylebox("panel")
	if stylebox is StyleBoxFlat:
		stylebox.bg_color = datos_nodo.color_titulo
	
	var total_filas = max(datos_nodo.entradas.size(), datos_nodo.salidas.size())
	
	# 2. Generar las filas de puertos dinámicamente
	for i in range(total_filas):
		var fila = HBoxContainer.new()
		fila.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var hay_izq = i < datos_nodo.entradas.size()
		var hay_der = i < datos_nodo.salidas.size()
		
		# Leer datos de los puertos o asignar valores vacíos si no hay en esa fila
		var tipo_izq = datos_nodo.entradas[i].tipo if hay_izq else 0
		var color_izq = COLORES_PUERTOS.get(tipo_izq, Color.WHITE)
		
		var tipo_der = datos_nodo.salidas[i].tipo if hay_der else 0
		var color_der = COLORES_PUERTOS.get(tipo_der, Color.WHITE)
		
		# Registramos los slots físicos en el motor de Godot
		set_slot(i, hay_izq, tipo_izq, color_izq, hay_der, tipo_der, color_der)
		
		# Etiqueta de entrada (Alineada a la izquierda)
		var label_izq = Label.new()
		label_izq.text = datos_nodo.entradas[i].nombre if hay_izq else ""
		fila.add_child(label_izq)
		
		# Muelle espaciador intermedio
		var separador = Control.new()
		separador.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fila.add_child(separador)
		
		# Etiqueta de salida (Alineada a la derecha)
		var label_der = Label.new()
		label_der.text = datos_nodo.salidas[i].nombre if hay_der else ""
		label_der.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		fila.add_child(label_der)
		
		add_child(fila)

# --- CAPTURA DE EVENTOS PARA LA MÁQUINA DE ESTADOS ---

func _on_node_dragged(_from: Vector2, _to: Vector2) -> void:
	if fsm and fsm.estado_actual != "Dragging":
		fsm.cambiar_a("Dragging")

func _on_node_drag_ended() -> void:
	# Al soltar el nodo, vuelve a su estado de reposo esperando ejecución
	if fsm:
		fsm.cambiar_a("Idle")
