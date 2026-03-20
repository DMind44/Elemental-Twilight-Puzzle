@tool
extends Area2D
@export var index : int
@export var adjacent = []

@export_tool_button("Sync Area to Polygon", "EditorIcons") var puzzle_create_button: Callable = _on_button_pressed

var is_dragging := false
var initial_pos := Vector2.ZERO
var mouse_inside := false
var drag_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_button_pressed():
	sync_area_to_polygon()

func sync_area_to_polygon():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon

func _on_mouse_entered():
	mouse_inside = true
	print("Mouse is hovering! Index: ", index)

func _on_mouse_exited():
	mouse_inside = false
	print("Mouse left the area. Index: ", index)


func _input(event):
	if mouse_inside and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		if event.is_pressed():
			print("click. Index: ", index)
			drag_offset = position - get_global_mouse_position()
			is_dragging = true
			move_to_front()
		if event.is_released():
			print("release. Index: ", index)
			is_dragging = false

func _process(_delta):
	if Engine.is_editor_hint():
		pass
	if is_dragging:
		position = get_global_mouse_position() + drag_offset
