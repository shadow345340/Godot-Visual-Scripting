@tool
extends Resource
class_name VisualNodeData

enum TipoPuerto { EJECUCION, ENTERO, FLOTANTE, STRING, BOOLEANO, VECTOR }

@export var nombre_nodo: String = "Nuevo Nodo"
@export var categoria: String = "Matemáticas"
@export var color_titulo: Color = Color(0.2, 0.25, 0.3)

# Definimos las variables listas para ser editadas individualmente desde el Inspector de Godot
@export var entradas: Array[Dictionary] = []
@export var salidas: Array[Dictionary] = []
