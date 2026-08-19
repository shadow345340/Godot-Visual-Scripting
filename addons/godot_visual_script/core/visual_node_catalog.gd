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
	var print_script = load("res://addons/godot_visual_script/nodes/components/node_class_print.gd")
	var text_script = load("res://addons/godot_visual_script/nodes/components/node_class_text.gd")
	var whole_script = load("res://addons/godot_visual_script/nodes/components/node_class_whole_number.gd")
	var decimal_script = load("res://addons/godot_visual_script/nodes/components/node_class_decimal_number.gd")
	var process_script = load("res://addons/godot_visual_script/nodes/components/node_class_on_process.gd")
	var input_script = load("res://addons/godot_visual_script/nodes/components/node_class_input_press.gd")
	var get_vel_script = load("res://addons/godot_visual_script/nodes/components/node_class_get_velocity.gd")
	var set_vel_script = load("res://addons/godot_visual_script/nodes/components/node_class_set_velocity.gd")
	var move_script = load("res://addons/godot_visual_script/nodes/components/node_class_move_and_slide.gd")
	
	if plus_script: database.append(plus_script.new())
	if equal_script: database.append(equal_script.new())
	if if_script: database.append(if_script.new())
	if impulse_script: database.append(impulse_script.new())
	if print_script: database.append(print_script.new())
	if text_script: database.append(text_script.new())
	if whole_script: database.append(whole_script.new())
	if decimal_script: database.append(decimal_script.new())
	if process_script: database.append(process_script.new())
	if input_script: database.append(input_script.new())
	if get_vel_script: database.append(get_vel_script.new())
	if set_vel_script: database.append(set_vel_script.new())
	if move_script: database.append(move_script.new())

func get_database() -> Array[Object]:
	return database
