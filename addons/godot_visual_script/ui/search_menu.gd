@tool
extends PopupPanel
class_name SearchMenu

signal nodo_seleccionado(datos: VisualNodeData, posicion_mouse: Vector2)

@onready var buscador: LineEdit = $VBoxContainer/Buscador
@onready var lista_nodos: ItemList = $VBoxContainer/ListaNodos

var catalogo_completo: Array[VisualNodeData] = []
var catalogo_filtrado: Array[VisualNodeData] = []
var posicion_click_lienzo: Vector2 = Vector2.ZERO

func _ready() -> void:
	size = Vector2i(280, 350)
	
	if not buscador.text_changed.is_connected(_on_texto_busqueda_cambiado):
		buscador.text_changed.connect(_on_texto_busqueda_cambiado)
	if not lista_nodos.item_activated.is_connected(_on_nodo_doble_click):
		lista_nodos.item_activated.connect(_on_nodo_doble_click)
	
	if not about_to_popup.is_connected(_on_about_to_popup):
		about_to_popup.connect(_on_about_to_popup)

func _on_about_to_popup() -> void:
	buscador.text = ""
	filtrar_catalogo("")
	# Espera un frame antes de darle el foco al buscador para evitar fallos de input en el editor
	await get_tree().process_frame
	if buscador:
		buscador.grab_focus()

func inicializar_catalogo(nuevos_nodos: Array[VisualNodeData]) -> void:
	catalogo_completo = nuevos_nodos
	filtrar_catalogo("")

func _on_texto_busqueda_cambiado(nuevo_texto: String) -> void:
	filtrar_catalogo(nuevo_texto)

func filtrar_catalogo(filtro: String) -> void:
	if not is_inside_tree() or lista_nodos == null:
		return
		
	lista_nodos.clear()
	catalogo_filtrado.clear()
	
	var filtro_min = filtro.to_lower().strip_edges()
	
	for nodo in catalogo_completo:
		if nodo == null:
			continue
			
		var nombre_min = nodo.nombre_nodo.to_lower()
		var cat_min = nodo.categoria.to_lower()
		
		if filtro_min == "" or filtro_min in nombre_min or filtro_min in cat_min:
			catalogo_filtrado.append(nodo)
			var texto_final = "[%s] %s" % [nodo.categoria, nodo.nombre_nodo]
			var indice = lista_nodos.add_item(texto_final)
			lista_nodos.set_item_custom_fg_color(indice, nodo.color_titulo.lightened(0.5))
			
	if lista_nodos.item_count == 0:
		lista_nodos.add_item("No se encontraron nodos...")

func _on_nodo_doble_click(index: int) -> void:
	if index >= 0 and index < catalogo_filtrado.size():
		nodo_seleccionado.emit(catalogo_filtrado[index], posicion_click_lienzo)
		hide()
