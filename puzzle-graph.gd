@tool
extends Node
class_name puzzle_graph

@export var num_pieces : int

@export var puzzle_data : PuzzleData

@export var position_matrix : Array[Transform2D]

@export_tool_button("Create puzzle matrix", "EditorIcons") var puzzle_create_button: Callable = _on_button_pressed

func _on_button_pressed():
	if Engine.is_editor_hint():
		set_puzzle_graph()
		puzzle_data.puzzle_graph = position_matrix


func set_puzzle_graph():
	var pieces = get_children()
	
	for piece in pieces:
		print("Piece: " , piece.index)
		position_matrix[piece.index] = piece.transform
