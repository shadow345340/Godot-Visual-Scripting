@tool
extends Resource
class_name VisualNodeData

enum TipoPuerto { EJECUCION, ENTERO, FLOTANTE, STRING, BOOLEANO, VECTOR }

@export var nombre_nodo: String = "Nuevo Nodo"
@export var categoria: String = "Matemáticas"
@export var color_titulo: Color = Color.DARK_SLATE_GRAY

# Estructuras para definir las entradas y salidas en el inspector de Godot
@export var entradas: Array[Dictionary] = [
	{"nombre": "Ejecutar", "tipo": TipoPuerto.EJECUCION},
	{"nombre": "A", "tipo": TipoPuerto.ENTERO}
]

@export var salidas: Array[Dictionary] = [
	{"nombre": "Luego", "tipo": TipoPuerto.EJECUCION},
	{"nombre": "Resultado", "tipo": TipoPuerto.ENTERO}
]
