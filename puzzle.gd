extends Node

@export var puzzle_data : PuzzleData
const OFFSET = 700

const INITIAL_POS = Vector2(-1400, -1400)

var current_pos = INITIAL_POS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	for i in puzzle_data.num_pieces:
		var piece = puzzle_data.pieces[i].instantiate()
		piece.position = current_pos
		if current_pos.x > OFFSET * 4 + INITIAL_POS.x:
			current_pos.x = INITIAL_POS.x
			current_pos.y += OFFSET
		else:
			current_pos.x += OFFSET
		add_child(piece)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
