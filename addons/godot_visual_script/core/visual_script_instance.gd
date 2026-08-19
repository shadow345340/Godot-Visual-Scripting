@tool
extends Node
class_name VisualScriptInstance

@export_file("*.gvs") var script_file: String = ""
@export var autoplay_on_start: bool = true

var interpreter: VisualScriptInterpreter
var is_active: bool = false
var process_node_name: String = ""

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if autoplay_on_start and script_file != "":
		load_and_initialize_script()

func load_and_initialize_script() -> void:
	if not FileAccess.file_exists(script_file):
		return
		
	var file = FileAccess.open(script_file, FileAccess.READ)
	if not file:
		return
		
	var text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	if json.parse(text) == OK:
		var graph_data = json.get_data()
		interpreter = VisualScriptInterpreter.new(graph_data)
		
		process_node_name = _find_node_by_class(graph_data, "node_class_on_process.gd")
		
		var starting_node = _find_entry_node(graph_data)
		if starting_node != "" and process_node_name == "":
			interpreter.run_script(starting_node, get_parent())
			
		is_active = true

func _process(delta: float) -> void:
	if Engine.is_editor_hint() or not is_active or interpreter == null:
		return
		
	if process_node_name != "":
		get_parent().set_meta("current_delta_time", delta)
		interpreter.run_script(process_node_name, get_parent())

func _find_entry_node(graph_data: Dictionary) -> String:
	for node_info in graph_data.get("nodes", []):
		var path = node_info.get("class_definition", "")
		if "node_class_print.gd" in path or "node_class_if.gd" in path or "node_class_impulse.gd" in path:
			return node_info.get("name", "")
	return ""

func _find_node_by_class(graph_data: Dictionary, class_filename: String) -> String:
	for node_info in graph_data.get("nodes", []):
		var path = node_info.get("class_definition", "")
		if class_filename in path:
			return node_info.get("name", "")
	return ""
