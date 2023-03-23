extends Projectile
class_name Grenade

#not used
@export var impact_area : Vector2 = Vector2(2, 2)
@export var max_launch_distance : float = 400
@export var landing_precision : int = 50

@onready var explosion_timer = $ExplosionTimer
@onready var explosion_area = $ExplosionArea
@onready var animation = $Animation

var bodies = []
var distance : float = 0
var lauching_position := Vector2.ZERO
var landing_position := Vector2.ZERO

func _ready():
	randomize()
	scale = scale * size

func _physics_process(delta):
	if direction != Vector2.ZERO:
		
		#lerp de velocity : + for au debut et reduit avec le temps
		var velocity = direction * GlobalFunctions.get_speed(speed, delta)
		global_position += velocity
		
	if speed == 0 or direction == Vector2.ZERO:
		return
	
	var range_safe := 5
	var distance_traveled := lauching_position.distance_to(global_position)
	if distance - range_safe <= distance_traveled and distance_traveled <= distance + range_safe:
		stop_or_bounce()

func stop_or_bounce():
	#si la distance parcourue n'était pas finit :
	# distance = distance / 2
	# direction = -direction
	speed = 0
	direction = Vector2.ZERO
	explosion_timer.start()

func _on_body_entered(body):
	if body.get_name() == "Walls":
		stop_or_bounce()
	if body is Character:
		stop_or_bounce()

func set_lauching_position(position: Vector2):
	self.lauching_position = position

func set_landing_position(landing_position: Vector2):
	self.landing_position = landing_position

func calulate_distance():
	distance = lauching_position.distance_to(landing_position)
	if distance > max_launch_distance:
		distance = max_launch_distance
	var range := randi() % landing_precision
	if randf()>0.5:
		range = -range
	distance += range

func _on_explosion_timer_timeout():
	animation.play("explosion")
	for body in bodies:
		if body == null:
			continue
		if body.has_method("handle_hit"):
			body.handle_hit(damages)
		if body.has_method("apply_force"):
			body.apply_force(body, self.direction, impact_force)
	bodies = []

func _on_explosion_area_body_entered(body):
	#print("owner name = ", get_parent())
	#print("body name = ", body.get_name(), "\n")
	if get_owner() != body:
		bodies.append(body)

func _on_explosion_area_body_exited(body):
	#bodies.remove(body)
	pass
