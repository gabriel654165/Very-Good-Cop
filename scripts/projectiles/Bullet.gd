extends Projectile
class_name Bullet

#bullet : distance de free & pas timer
#bullet ; saignement

@export var piercing_force : int = 2

@onready var life_cycle_timer = $LifeCycleTimer

var current_piercing_force : int = 0

func _ready():
	life_cycle_timer.start()
	scale = scale * size
	current_piercing_force = piercing_force

func _physics_process(delta):
	_move_and_collide(delta)

func handle_collision(collision: KinematicCollision2D):
	if !collision:
		return
	var object = collision.get_collider()
	
	if object.get_name() == "Walls":
		queue_free()
	
	if object.has_method("handle_hit"):
		current_piercing_force -= 1
		object.handle_hit(damages)

	if object.has_method("apply_force"):
		object.apply_force(object, self.direction, impact_force)

	if current_piercing_force <= 0:
		queue_free()

#signals
func _on_life_cycle_timer_timeout():
	queue_free()

