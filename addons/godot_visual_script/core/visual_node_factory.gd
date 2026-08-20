@tool
extends Object
class_name VisualNodeFactory

static func spawn_node(scene: PackedScene, class_instance: Object, position: Vector2, parent_canvas: GraphEdit) -> void:
	if not parent_canvas or not scene: 
		return
		
	# Instanciamos la escena real .tscn que contiene la FSM y los componentes visuales
	var new_node = scene.instantiate()
	new_node.position_offset = position
	
	# Inicializamos los puertos y el nombre de la clase en memoria
	if new_node.has_method("initialize_with_class"):
		new_node.initialize_with_class(class_instance)
		
	# Lo añadimos de golpe al lienzo del GraphEdit
	parent_canvas.add_child(new_node)
