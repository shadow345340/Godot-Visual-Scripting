@tool
extends Object
class_name VisualNodeStyle

static func setup_canvas_theme(graph_edit: GraphEdit) -> void:
	if not graph_edit: return
	graph_edit.connection_lines_curvature = 0.0
	graph_edit.connection_lines_thickness = 3.0

static func apply_isolated_node_color(node: GraphNode) -> void:
	if not node: return
	
	# Duplicamos los estilos del motor para que cada nodo tenga el suyo propio y no compartan bordes
	var base_box = node.get_theme_stylebox("panel")
	var active_box = node.get_theme_stylebox("panel_selected")
	
	if base_box is StyleBoxFlat:
		var new_base = base_box.duplicate() as StyleBoxFlat
		new_base.bg_color = Color(0.12, 0.12, 0.12, 1.0) # Gris oscuro limpio de fondo
		new_base.border_width_left = 0
		new_base.border_width_top = 0
		new_base.border_width_right = 0
		new_base.border_width_bottom = 0
		node.add_theme_stylebox_override("panel", new_base)
		
	if active_box is StyleBoxFlat:
		var new_active = active_box.duplicate() as StyleBoxFlat
		new_active.bg_color = Color(0.12, 0.12, 0.12, 1.0)
		new_active.border_color = Color(0.9, 0.9, 0.9, 1.0) # Borde claro limpio SOLO para el seleccionado
		new_active.border_width_left = 2
		new_active.border_width_top = 2
		new_active.border_width_right = 2
		new_active.border_width_bottom = 2
		node.add_theme_stylebox_override("panel_selected", new_active)
