extends Projectile
class_name Bullet

#bullet : distance de free & pas timer
#bullet : ricochet 1 fois sur les murs
#bullet ; saignement

@export var piercing_force : int = 2

@onready var life_cycle_timer = $LifeCycleTimer

var current_piercing_force : int = 0

func _ready():
	life_cycle_timer.start()
	scale = scale * size
	current_piercing_force = piercing_force

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * GlobalFunctions.get_speed(speed, delta)
		global_position += velocity

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
