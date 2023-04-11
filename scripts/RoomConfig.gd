extends Node2D
class_name RoomConfig

@export var patrol_points: Array[Node2D]

func _ready():
	patrol_points = []
	for child in get_children():
		if child is Node2D:
			patrol_points.push_back(child)
