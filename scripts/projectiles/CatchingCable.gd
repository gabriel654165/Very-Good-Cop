extends Projectile
class_name CatchingCable

@export var expand_magnitude_factor : Vector2 = Vector2(2, 0)

@onready var ball_left = $BallLeft as Projectile
@onready var ball_right = $BallRight as Projectile
@onready var cable = $Line2D
@onready var cable_collider = $Area2D/CollisionShape2D
@onready var timer_cable_retention = $TimerCableRetention

var shooting_direction := Vector2.ZERO
var is_expanding : bool = true
var is_retracting : bool = false
var objects_catched_array : Array[Node2D] = []
var saved_enemy_speed : Array[float] = []

func _specific_process(delta):
	if ball_left == null or ball_right == null:
		queue_free()
		return
	set_cable_points()
	set_cable_collision_shapes()
	if is_retracting and is_cable_closed():
		is_retracting = false
		stop()
		drag_objects_catched_to_center()

func drag_objects_catched_to_center():
	for object in objects_catched_array:
		if object is Enemy and object != null:
			saved_enemy_speed.append(object.speed)
			object.set_speed(0)
	timer_cable_retention.start()
	print("speed stopped and timer started")
	#prendre le point le plus loin d'une boule
	#faire cePoint - maBoule = centre
	#les drag au centre (tween ?)

func set_cable_points():
	if ball_left == null or ball_right == null:
		return
	
	var points_array : Array = []
	var index : int = 0
	
	points_array.append(ball_left.position)
	for object in objects_catched_array:
		if object != null:
			points_array.append(cable.to_local(object.global_position))
			index += 1
		else:
			objects_catched_array.remove_at(index)
	points_array.append(ball_right.position)
	cable.points = PackedVector2Array(points_array)

func process_retract():
	if is_retracting:
		return
	#print("-->retracting<--")
	is_retracting = true
	
	var left_direction = shooting_direction
	var right_direction = shooting_direction
	if shooting_direction.normalized().x > 0.5 or shooting_direction.normalized().x < -0.5:
		# droite gauche
		left_direction.y -= -1 if (shooting_direction.normalized().x > 0.5) else 1
		right_direction.y -= 1 if (shooting_direction.normalized().x > 0.5) else -1
	if shooting_direction.normalized().y > 0.5 or shooting_direction.normalized().y < -0.5:
		# haut bas
		left_direction.x -= 1 if (shooting_direction.normalized().y > 0.5) else -1
		right_direction.x -= -1 if (shooting_direction.normalized().y > 0.5) else 1
	ball_left.set_direction(left_direction.normalized())
	ball_right.set_direction(right_direction.normalized())

func set_cable_collision_shapes():
	if ball_left == null or ball_right == null:
		return
	#print("cable_collider.shape.b = ", cable_collider.shape.b)
	#print("cable_collider.shape.a = ", cable_collider.shape.a, "\n")
	cable_collider.shape.a = cable_collider.to_local(ball_right.global_position)
	cable_collider.shape.b = cable_collider.to_local(ball_left.global_position)


func handle_specific_collision(object: Object):
	if object.name == "Walls":
		queue_free()
		return

func stop_expand():
	is_expanding = false
	if ball_left == null or ball_right == null:
		return
	#print("stop expand")
	ball_left.direction = shooting_direction.normalized()
	ball_right.direction = shooting_direction.normalized()

func stop():
	speed = 0
	direction = Vector2.ZERO
	ball_right.speed = 0
	ball_right.direction = Vector2.ZERO
	ball_left.speed = 0
	ball_left.direction = Vector2.ZERO

func is_cable_closed() -> bool:
	var ball_right_pos = ball_right.global_position
	var ball_left_pos = ball_left.global_position
	var rl : bool = false
	var td : bool = false
	
	# right and left
	if shooting_direction.x > 0.5 or shooting_direction.x < -0.5:
		rl = true if (shooting_direction.x > 0.5 and ball_right_pos.y < ball_left_pos.y) else rl
		rl = true if (shooting_direction.x < -0.5 and ball_right_pos.y > ball_left_pos.y) else rl
	# up and down
	if shooting_direction.y < -0.5 or shooting_direction.y > 0.5:
		td = true if (shooting_direction.y < -0.5 and ball_right_pos.x < ball_left_pos.x) else td
		td = true if (shooting_direction.y > 0.5 and ball_right_pos.x > ball_left_pos.x) else td
	
	return rl or td

# signals
func _on_timer_stop_expend_timeout():
	if !is_retracting:
		stop_expand()
	#process_retract()

func _on_timer_cable_retention_timeout():
	var index : int = 0
	for object in objects_catched_array:
		if object is Enemy && object != null && saved_enemy_speed[index] != null:
			object.set_speed(saved_enemy_speed[index])
			index += 1
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Walls":
		queue_free()
		return
	if body is Enemy and !objects_catched_array.has(body):
		#print("Collide on enemy")
		if objects_catched_array.size() == 0:
			process_retract()
		objects_catched_array.append(body)
