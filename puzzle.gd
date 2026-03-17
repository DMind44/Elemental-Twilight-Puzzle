extends Node

@export var puzzle_data : PuzzleData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	for i in puzzle_data.num_pieces:
		add_child(puzzle_data.pieces[i].instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
