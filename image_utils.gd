@tool
extends Polygon2D

@export_tool_button("Center Polygon", "EditorIcons") var my_button: Callable = _on_button_pressed

func _on_button_pressed():
	if Engine.is_editor_hint():
		print("Polygon centered!")
		center_polygon()


func get_polygon_center() -> Vector2:
	var points = polygon
	var center := Vector2.ZERO
	for point in points:
		center += point
	if not points.is_empty():
		center /= points.size()
	return center

func center_polygon():
	var center = get_polygon_center()
	# Offset the polygon points so the center is at (0, 0) in local space
	var adjusted_points = []
	for point in polygon:
		adjusted_points.append(point - center)
	polygon = adjusted_points
	
	# Optional: If you want the node's global position to remain the same,
	# you must also move the node by the calculated center.
	# self.position += center 
