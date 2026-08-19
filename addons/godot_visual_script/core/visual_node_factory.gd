@tool
extends Object
class_name VisualNodeFactory

static func spawn_node(scene: PackedScene, class_instance: Object, position: Vector2, parent_canvas: GraphEdit) -> void:
	if not parent_canvas or not scene: return
	
	var new_node = scene.instantiate()
	new_node.position_offset = position
	
	# Primero inicializamos los datos en memoria en microsegundos
	if new_node.has_method("initialize_with_class"):
		new_node.initialize_with_class(class_instance)
		
	# Segundo lo mandamos al lienzo de golpe
	parent_canvas.add_child(new_node)
