extends Projectile
class_name Bullet

#bullet : distance de free & pas timer

@onready var life_cycle_timer = $LifeCycleTimer

func _ready():
	life_cycle_timer.start()
	scale = scale * size
	current_piercing_force = piercing_force

func handle_specific_collision(object: Object):
	if object.has_method("handle_hit"):
		object.handle_hit(self, damages)
	if object.has_method("apply_force"):
		object.apply_force(object, self.direction, impact_force)

#signals
func _on_life_cycle_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Character:
		current_piercing_force -= 1
	
	if body.get_name() == "Walls":
		if should_pierce_walls:
			current_piercing_force -= 2
	
	if current_piercing_force <= 0:
		queue_free()

func _on_area_2d_body_exited(body):
	if body.get_name() == "Walls":
		# Sprite animation go throught wall
		return
