@tool
extends Area2D
@export var index : int

@export_tool_button("Sync Area to Polygon", "EditorIcons") var puzzle_create_button: Callable = _on_button_pressed

const CONNECTION_SCENE = preload("res://connection.tscn")
@onready var puzzle_data: PuzzleData = get_node("/root/Global").data

var is_dragging := false
var initial_pos := Vector2.ZERO
var drag_offset := Vector2.ZERO

var connection_offset := Vector2.ZERO
var is_grouped := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	input_pickable = true
	input_event.connect(_on_input_event)


func _on_button_pressed():
	sync_area_to_polygon()

func sync_area_to_polygon():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	


func snap_piece():
	var overlapping = get_overlapping_areas()
	for area in overlapping:
		if puzzle_data.get_adjacency(index, area.index):
			print(index, " is adjacent to ", area.index)
			var snap_offset = puzzle_data.puzzle_graph[index] - puzzle_data.puzzle_graph[area.index]
			var target = area.global_position + snap_offset
			print("position: ", global_position, " target: ", target)
			var inside = is_inside_polygon(target)
			
			if inside and is_grouped and area.is_grouped:
				snap_groups(area, target)
				break
			elif inside and area.is_grouped:
				snap_to_grouped(area, target)
				break
			elif inside and is_grouped:
				snap_grouped_to_single(area, target)
				break
			elif inside:
				position = target
				var new_connection = CONNECTION_SCENE.instantiate()
				get_parent().add_child(new_connection)
				reparent(new_connection)
				area.reparent(new_connection)
				puzzle_data.clear_adjacency(index, area.index)
				is_grouped = true
				area.is_grouped = true
				break


	
				

func is_inside_polygon(global_point: Vector2) -> bool:
	var polygon_node = $CollisionPolygon2D
	# Convert the global point to the polygon's local coordinate space
	var local_point = polygon_node.to_local(global_point)
	# Perform the check using the polygon points array
	return Geometry2D.is_point_in_polygon(local_point, polygon_node.polygon)	

func snap_to_grouped(grouped: Area2D, target: Vector2):
	var group = grouped.get_parent()
	position = target
	reparent(group)
	is_grouped = true
	for piece in group.get_children():
		puzzle_data.clear_adjacency(index, piece.index)
	
func snap_grouped_to_single(other: Area2D, target: Vector2):
	var group = get_parent()
	var snap_group_offset = group.position - global_position
	set_group_position(target, snap_group_offset)
	other.is_grouped = true
	for piece in group.get_children():
		puzzle_data.clear_adjacency(other.index, piece.index)
	other.reparent(group)
	
	
func snap_groups(other: Area2D, target):
	var group = get_parent()
	var snap_group_offset = group.position - global_position
	set_group_position(target, snap_group_offset)
	var other_group = other.get_parent()
	
	for i in group.get_children():
		for j in other_group.get_children():
			puzzle_data.clear_adjacency(i.index, j.index)
		i.reparent(other_group)

func _on_input_event(viewport, event, shape_idx) -> void:
	print("input event")
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		is_dragging = true
		drag_offset = global_position - get_global_mouse_position()
		
		if is_grouped:
			connection_offset = get_parent().global_position - get_global_mouse_position()
			for piece in get_parent().get_children():
				piece.move_to_front()
		else:
			move_to_front()

		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if is_dragging \
	and event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		is_dragging = false
		snap_piece()

func set_group_position(target: Vector2, offset: Vector2):
	get_parent().position = target + offset
	

func _process(_delta):
	if Engine.is_editor_hint():
		pass
	if is_dragging and is_grouped:
		set_group_position(get_global_mouse_position(), connection_offset)
	elif is_dragging:
		position = get_global_mouse_position() + drag_offset
