extends Resource

class_name PuzzleData



@export var puzzle_graph : Array[Vector2]
@export var adjacency_matrix : Array[int]

@export var num_pieces : int

@export var pieces : Array[PackedScene]

func get_adjacency(x, y) -> int:
	return adjacency_matrix[y * num_pieces + x]

func clear_adjacency(x, y):
	adjacency_matrix[y * num_pieces + x] = 0
	adjacency_matrix[x * num_pieces + y] = 0
