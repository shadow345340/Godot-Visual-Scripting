@tool
extends RefCounted
class_name VisualNodeCatalog

var database: Array[Object] = []

func load_components() -> void:
	database.clear()
	
	var plus_script = load("res://addons/godot_visual_script/nodes/components/node_class_plus.gd")
	var subtract_script = load("res://addons/godot_visual_script/nodes/components/node_class_subtract.gd")
	var multiply_script = load("res://addons/godot_visual_script/nodes/components/node_class_multiply.gd")
	var divide_script = load("res://addons/godot_visual_script/nodes/components/node_class_divide.gd")
	var equal_script = load("res://addons/godot_visual_script/nodes/components/node_class_equal.gd")
	
	var if_script = load("res://addons/godot_visual_script/nodes/components/node_class_if.gd")
	var and_script = load("res://addons/godot_visual_script/nodes/components/node_class_logical_and.gd")
	var or_script = load("res://addons/godot_visual_script/nodes/components/node_class_logical_or.gd")
	var not_script = load("res://addons/godot_visual_script/nodes/components/node_class_logical_not.gd")
	
	var text_script = load("res://addons/godot_visual_script/nodes/components/node_class_text.gd")
	var whole_script = load("res://addons/godot_visual_script/nodes/components/node_class_whole_number.gd")
	var decimal_script = load("res://addons/godot_visual_script/nodes/components/node_class_decimal_number.gd")
	var const_bool_script = load("res://addons/godot_visual_script/nodes/components/node_class_constant_bool.gd")
	
	var vector2_script = load("res://addons/godot_visual_script/nodes/components/node_class_vector2.gd")
	var vector3_script = load("res://addons/godot_visual_script/nodes/components/node_class_vector3.gd")
	
	var process_script = load("res://addons/godot_visual_script/nodes/components/node_class_on_process.gd")
	var input_script = load("res://addons/godot_visual_script/nodes/components/node_class_input_press.gd")
	var axis_script = load("res://addons/godot_visual_script/nodes/components/node_class_input_axis.gd")
	var just_press_script = load("res://addons/godot_visual_script/nodes/components/node_class_input_just_pressed.gd")
	
	var get_vel_script = load("res://addons/godot_visual_script/nodes/components/node_class_get_velocity.gd")
	var set_vel_script = load("res://addons/godot_visual_script/nodes/components/node_class_set_velocity.gd")
	var move_script = load("res://addons/godot_visual_script/nodes/components/node_class_move_and_slide.gd")
	var gravity_script = load("res://addons/godot_visual_script/nodes/components/node_class_apply_gravity.gd")
	
	if plus_script: database.append(plus_script.new())
	if subtract_script: database.append(subtract_script.new())
	if multiply_script: database.append(multiply_script.new())
	if divide_script: database.append(divide_script.new())
	if equal_script: database.append(equal_script.new())
	
	if if_script: database.append(if_script.new())
	if and_script: database.append(and_script.new())
	if or_script: database.append(or_script.new())
	if not_script: database.append(not_script.new())
	
	if text_script: database.append(text_script.new())
	if whole_script: database.append(whole_script.new())
	if decimal_script: database.append(decimal_script.new())
	if const_bool_script: database.append(const_bool_script.new())
	
	if vector2_script: database.append(vector2_script.new())
	if vector3_script: database.append(vector3_script.new())
	
	if process_script: database.append(process_script.new())
	if input_script: database.append(input_script.new())
	if axis_script: database.append(axis_script.new())
	if just_press_script: database.append(just_press_script.new())
	
	if get_vel_script: database.append(get_vel_script.new())
	if set_vel_script: database.append(set_vel_script.new())
	if move_script: database.append(move_script.new())
	if gravity_script: database.append(gravity_script.new())

func get_database() -> Array[Object]:
	return database
