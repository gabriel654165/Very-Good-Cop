extends Node2D
class_name RoomConfig

var patrol_points: Array[Vector2] = []

func _ready():
	var children = find_child("PatrolPoints").get_children()
	for child in children:
		if child is Node2D:
			patrol_points.push_back(child.global_position)
