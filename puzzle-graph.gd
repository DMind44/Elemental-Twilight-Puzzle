@tool
extends Node
class_name puzzle_graph

@export var num_pieces : int

@export var puzzle_data : PuzzleData

@export var position_matrix : Array[Vector2]

@export var adjacency_matrix : Array[int] = []

@export_tool_button("Create puzzle matrix", "EditorIcons") var puzzle_create_button: Callable = _on_button_pressed

@export_tool_button("Get adjacencies", "EditorIcons") var adjacency_button: Callable = _adjacency_button_pressed

func _ready():
	if Engine.is_editor_hint() and len(adjacency_matrix) == 0:
		adjacency_matrix.resize(num_pieces*num_pieces)

func _on_button_pressed():
	if Engine.is_editor_hint():
		set_puzzle_graph()
		puzzle_data.puzzle_graph = position_matrix

func _adjacency_button_pressed():
	if Engine.is_editor_hint():
		set_adjacencies()
		puzzle_data.adjacency_matrix = adjacency_matrix
		
		
func set_adjacencies():
	PhysicsServer2D.set_active(true)
	for child in get_children():
		if child is Area2D:
			await get_tree().physics_frame
			var overlapping = child.get_overlapping_areas()
			for area in overlapping:
				print(child.index, " is overlapping with ", area.index)
				#child.adjacent[area.index] = 1
				set_cell(child.index, area.index, 1)
	PhysicsServer2D.set_active(false)

func set_cell(x, y, value):
	adjacency_matrix[y * num_pieces + x] = value

func get_cell(x, y):
	return adjacency_matrix[y * num_pieces + x]

func set_puzzle_graph():
	var pieces = get_children()
	
	for piece in pieces:
		print("Piece: " , piece.index)
		position_matrix[piece.index] = piece.position
