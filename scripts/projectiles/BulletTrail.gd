extends Line2D
class_name ShootingTrail

@export var trail_length = 5

@export var bullet_instance : Node


func _ready():
	if bullet_instance == null:
		print("bullet_instance null")

func _process(delta):
	if bullet_instance == null:
		return
	
	global_position = Vector2.ZERO
	global_rotation = 0.0
	
	var x = to_local(bullet_instance.global_position).x
	var y = to_local(bullet_instance.global_position).y
	var point = Vector2(x, y)
	add_point(point)
	
	while get_point_count() > trail_length:
		remove_point(0)
