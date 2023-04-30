extends Projectile
class_name CatchingCable

@export var expand_magnitude_factor : Vector2 = Vector2(2, 0)

@onready var ball_left = $BallLeft as Projectile
@onready var ball_right = $BallRight as Projectile
@onready var cable = $Line2D
@onready var cable_collider = $Area2D/CollisionShape2D

var shooting_direction := Vector2.ZERO
var is_expanding : bool = true
var is_retracting : bool = false
var objects_catched_array : Array[Node2D] = []

func _specific_process(delta):
	if ball_left == null or ball_right == null:
		free_obj()
		return
	set_cable_points()
	set_cable_collision_shapes()

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
	print("-------------->retracting<-----------------")
	is_retracting = true
	
	if shooting_direction.normalized().x > 0.5 or shooting_direction.normalized().x < -0.5:
		ball_left.direction.y = -ball_left.direction.y
		ball_right.direction.y = -ball_right.direction.y
	elif shooting_direction.normalized().y > 0.5 or shooting_direction.normalized().y < -0.5:
		ball_left.direction.x = -ball_left.direction.x
		ball_right.direction.x = -ball_right.direction.x
	
	#retract and attract characters on the line in the middle

func set_cable_collision_shapes():
	if ball_left == null or ball_right == null:
		return
	#print("cable_collider.shape.b = ", cable_collider.shape.b)
	#print("cable_collider.shape.a = ", cable_collider.shape.a, "\n")
	cable_collider.shape.a = cable_collider.to_local(ball_right.global_position)
	cable_collider.shape.b = cable_collider.to_local(ball_left.global_position)


func handle_specific_collision(object: Object):
	if object.name == "Walls":
		free_obj()
		return

func stop_expand():
	is_expanding = false
	if ball_left == null or ball_right == null:
		return
	#print("stop expand")
	ball_left.direction = shooting_direction.normalized()
	ball_right.direction = shooting_direction.normalized()

func free_obj():
	cable_collider.queue_free()
	queue_free()

# signals
func _on_timer_stop_expend_timeout():
	if !is_retracting:
		stop_expand()
	#process_retract()

func _on_area_2d_body_entered(body):
	if body.name == "Walls":
		free_obj()
		return
	if body is Enemy and !objects_catched_array.has(body):
		print("Collide on enemy")
		if objects_catched_array.size() == 0:
			process_retract()
		objects_catched_array.append(body)

