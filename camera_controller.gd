extends Camera2D


var dragging = false
var last_mouse_pos = Vector2.ZERO


@export var zoom_speed = 0.1
@export var min_zoom = 0.01
@export var max_zoom = 2.0
@export var initial_zoom = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_zoom(initial_zoom)


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		_change_zoom(zoom_speed)
	elif event.is_action_pressed("zoom_out"):
		_change_zoom(-zoom_speed)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.pressed:
			dragging = true
			last_mouse_pos = event.position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position -= delta / zoom.x # Adjust based on zoom level
		last_mouse_pos = event.position

func _set_zoom(level):
	zoom = Vector2(level, level)
	
	
func _change_zoom(increment):
	# Calculate new zoom level
	var new_zoom = zoom.x + increment
	# Clamp to allowed range
	new_zoom = clamp(new_zoom, min_zoom, max_zoom)
	# Apply to both X and Y for uniform zooming
	zoom = Vector2(new_zoom, new_zoom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
