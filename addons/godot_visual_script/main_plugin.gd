
@tool
extends EditorPlugin

const CANVAS_ESCENA = preload("res://addons/godot_visual_script/ui/visual_script_canvas.tscn")
var lienzo_instancia: Control

func _enter_tree() -> void:
	lienzo_instancia = CANVAS_ESCENA.instantiate()
	
	# Forzamos que la interfaz se expanda al máximo espacio disponible del editor
	lienzo_instancia.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lienzo_instancia.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	EditorInterface.get_editor_main_screen().add_child(lienzo_instancia)
	_make_visible(false)

func _exit_tree() -> void:
	if lienzo_instancia:
		lienzo_instancia.queue_free()

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "Visual Script"

# OBLIGATORIO: Controla la visibilidad real de la ventana dentro de Godot
func _make_visible(visible: bool) -> void:
	if lienzo_instancia:
		lienzo_instancia.visible = visible
		if visible:
			# Forzamos una actualización visual para que no se quede congelado en negro
			lienzo_instancia.queue_redraw()
