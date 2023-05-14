extends Area2D

@onready var starting_rotation := self.rotation
@export var decreasing_speed := 0.25
@export var opening_deg_angle := 25
@export var max_deg_angle := 150
@export var distance_from_the_hinge_force_factor := 800.0

var door_speed_rad := 0.0


func _on_body_entered(body:Node2D):
	if (body.name == "Walls"):
		return
	var door_origin_to_body := (body.global_position - global_position)
	var door_rotation_vector := Vector2.from_angle(rotation)
	var body_collision_angle := door_origin_to_body.angle_to(door_rotation_vector)
	
	if body_collision_angle == 0:
		return

	var rotation_is_clockwise := body_collision_angle > 0

	var magnitude := door_origin_to_body.length()

	var magnitude_force_factor : float = distance_from_the_hinge_force_factor/magnitude # The closer we are to door's hinge, the faster it will go

	var clockwise_factor := 1 if rotation_is_clockwise else -1 
	
	door_speed_rad = deg_to_rad(opening_deg_angle) * (magnitude_force_factor) * clockwise_factor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (door_speed_rad == 0):
		return
	elif (door_speed_rad < 0):
		door_speed_rad = min(door_speed_rad + decreasing_speed, 0)
	else:
		door_speed_rad = max(door_speed_rad - decreasing_speed, 0)

	if ((door_speed_rad > 0 and rad_to_deg(rotation + door_speed_rad * delta) - rad_to_deg(starting_rotation) > max_deg_angle)
		or (door_speed_rad < 0 and rad_to_deg(rotation + door_speed_rad * delta) - rad_to_deg(starting_rotation) < -max_deg_angle)):
		door_speed_rad = 0
		return

	rotate(door_speed_rad * delta)
