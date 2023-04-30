extends Projectile
class_name CatchingCable

@export var expand_magnitude_factor : Vector2 = Vector2(2, 0)

@onready var ball_left = $BallLeft as Projectile
@onready var ball_right = $BallRight as Projectile
@onready var cable = $Line2D
@onready var cable_collider = $CollisionShape2D

var shooting_direction := Vector2.ZERO
var is_expanding : bool = true
var is_retracting : bool = false

var objects_catched_array : Array[Node2D] = []

func _specific_process(delta):
	resize_cable()

func handle_specific_collision(object: Object):
	if object.name == "Walls":
		stop()
	if object is Enemy:
		print("Collide on enemy")
		objects_catched_array.append(object)
		cable.points.insert(cable.points.size() - 1, self.to_local(object.global_position))
		process_retract()

func add_cable_point(object: Node2D):
	pass

func resize_cable():
	if ball_left == null or ball_right == null:
		queue_free()
		return
	
	cable.points[0] = ball_left.position#[0 ball left]
	
	#[tout les enemy points] = enemy.to_local().?position
	var index : int = 1
	for object in objects_catched_array:
		cable.points.set(index, self.to_local(object.global_position))
		index += 1
	
	cable.points[cable.points.size() - 1] = ball_right.position #[end] ball right
	
	cable_collider.shape.a = ball_right.position
	cable_collider.shape.b = ball_left.position

func process_retract():
	if is_retracting:
		return
	#print("retracting")
	is_retracting = true
	
	if shooting_direction.normalized().x > 0.5 or shooting_direction.normalized().x < -0.5:
		ball_left.direction.y = -ball_left.direction.y
		ball_right.direction.y = -ball_right.direction.y
	if shooting_direction.normalized().y > 0.5 or shooting_direction.normalized().y < -0.5:
		ball_left.direction.x = -ball_left.direction.x
		ball_right.direction.x = -ball_right.direction.x
	
	#retract and attract characters on the line in the middle

func stop_expand():
	#print("stop expand")
	is_expanding = false
	ball_left.direction = shooting_direction
	ball_right.direction = shooting_direction

func stop():
	stop_expand()
	speed = 0
	direction = Vector2.ZERO

# signals
func _on_timer_retract_timeout():
	if !is_retracting:
		stop_expand()
