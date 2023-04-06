extends Projectile
class_name Grenade

@export var radius_pixels_impact_area : float = 100
@export var max_launch_distance : float = 400
@export var landing_precision : int = 1

@onready var explosion_timer = $ExplosionTimer
@onready var explosion_area = $ExplosionArea
@onready var explosion_area_shape = get_node("ExplosionArea/ExplosionCollisionShape2D")

@onready var animation = $Animation

var bodies = []
var distance : float = 0
var lauching_position := Vector2.ZERO
var landing_position := Vector2.ZERO

func _ready():
	randomize()
	scale = scale * size
	explosion_area_shape.get_shape().set_radius(radius_pixels_impact_area)

func _physics_process(delta):
	if direction != Vector2.ZERO:
		#lerp de velocity : + for au debut et reduit avec le temps
		
		velocity = direction * GlobalFunctions.get_speed(speed, delta)
		global_position += velocity
		var collision = move_and_collide(velocity * delta + velocity.normalized())
		
		handle_colision(collision)
		
	if speed == 0 or direction == Vector2.ZERO:
		return
	
	var range_safe := 5
	var distance_traveled := lauching_position.distance_to(global_position)
	if distance - range_safe <= distance_traveled and distance_traveled <= distance + range_safe:
		stop()

func handle_colision(collision: KinematicCollision2D):
	if !collision:
		return
	var object = collision.get_collider()
	
	if object is Character:
		stop()
		explode()
		return
	
	if object.name == "Walls":
		direction = velocity.normalized().bounce(collision.get_normal())
	
	return

func stop():
	speed = 0
	direction = Vector2.ZERO
	explosion_timer.start()

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

func explode():
	animation.play("explosion")
	bodies = explosion_area.get_overlapping_bodies()
	#print("Explosion on : ", bodies, "\n")
	for body in bodies:
		if body == null:
			continue
		if body.has_method("handle_hit"):
			body.handle_hit(damages)
		if body.has_method("apply_force"):
			var impact_direction = body.global_position - self.global_position
			body.apply_force(body, impact_direction, impact_force)
		#si c une grenade explose
		#if body is Grenade and body != self:
		#	body.explode()
	bodies = []

func _on_explosion_timer_timeout():
	explode()
