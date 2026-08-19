@tool
extends RefCounted
class_name VisualNodeCatalog

var database: Array[Object] = []

func load_components() -> void:
	database.clear()
	var plus_script = load("res://addons/godot_visual_script/nodes/components/node_class_plus.gd")
	var equal_script = load("res://addons/godot_visual_script/nodes/components/node_class_equal.gd")
	var if_script = load("res://addons/godot_visual_script/nodes/components/node_class_if.gd")
	var impulse_script = load("res://addons/godot_visual_script/nodes/components/node_class_impulse.gd")
	
	if plus_script: database.append(plus_script.new())
	if equal_script: database.append(equal_script.new())
	if if_script: database.append(if_script.new())
	if impulse_script: database.append(impulse_script.new())

func get_database() -> Array[Object]:
	return database
