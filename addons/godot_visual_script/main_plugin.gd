@tool
extends EditorPlugin

const CANVAS_SCENE = preload("res://addons/godot_visual_script/ui/visual_script_canvas.tscn")
var canvas_instance: Control

func _enter_tree() -> void:
	canvas_instance = CANVAS_SCENE.instantiate()
	canvas_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	canvas_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
	EditorInterface.get_editor_main_screen().add_child(canvas_instance)
	_make_visible(false)

func _exit_tree() -> void:
	if canvas_instance:
		canvas_instance.queue_free()

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "Visual Script"

func _make_visible(visible: bool) -> void:
	if canvas_instance:
		canvas_instance.visible = visible
