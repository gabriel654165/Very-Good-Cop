extends Area2D
class_name Bullet

@export var speed : int = 4
@export var damages : int = 20
@export var size : int = 1
@export var piercing_force : int = 2
@export var impact_force : int = 2

@onready var life_cycle_timer = $LifeCycleTimer

var current_piercing_force : int = 0
var direction := Vector2.ZERO

func _ready():
	life_cycle_timer.start()
	scale = scale * size
	current_piercing_force = piercing_force

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * GlobalFunctions.get_speed(speed, delta)
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()

#signals
func _on_life_cycle_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.get_name() == "Walls":
		queue_free()
	
	if body.has_method("handle_hit"):
		current_piercing_force -= 1
		body.handle_hit(damages)

	if body.has_method("apply_force"):
		body.apply_force(body, self.direction, impact_force)

	if current_piercing_force <= 0:
		queue_free()
