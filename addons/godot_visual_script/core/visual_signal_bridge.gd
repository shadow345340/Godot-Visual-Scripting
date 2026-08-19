@tool
extends RefCounted
class_name VisualSignalBridge

var graph_edit: GraphEdit
var canvas: Control

func _init(p_graph_edit: GraphEdit, p_canvas: Control) -> void:
	graph_edit = p_graph_edit
	canvas = p_canvas

func connect_signals() -> void:
	if graph_edit.connection_request.is_connected(canvas._on_connection_request): graph_edit.connection_request.disconnect(canvas._on_connection_request)
	if graph_edit.disconnection_request.is_connected(canvas._on_disconnection_request): graph_edit.disconnection_request.disconnect(canvas._on_disconnection_request)
	if graph_edit.delete_nodes_request.is_connected(canvas._on_delete_nodes_request): graph_edit.delete_nodes_request.disconnect(canvas._on_delete_nodes_request)
	if graph_edit.popup_request.is_connected(canvas._on_canvas_right_click): graph_edit.popup_request.disconnect(canvas._on_canvas_right_click)
	
	graph_edit.connection_request.connect(canvas._on_connection_request)
	graph_edit.disconnection_request.connect(canvas._on_disconnection_request)
	graph_edit.delete_nodes_request.connect(canvas._on_delete_nodes_request)
	graph_edit.popup_request.connect(canvas._on_canvas_right_click)
