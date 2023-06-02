extends Projectile
class_name Bullet

#bullet : distance de free & pas timer

@onready var life_cycle_timer = $LifeCycleTimer

func _ready():
	life_cycle_timer.start()
	scale = scale * size
	current_piercing_force = piercing_force


func init_frag_bullet():
	var frag_bullet = self.duplicate()
	var direction = self.direction
	
	direction += Vector2(_random_range(frag_projectile_precision_angle), 0)
	frag_bullet.direction = direction
	frag_bullet.should_frag = false
	frag_bullet.get_node("LifeCycleTimer").wait_time = 0.2
	GlobalSignals.projectile_fired_spawn.emit(null, frag_bullet, global_position, direction)


func _random_range(angle: Vector2) -> float:
	var range : float = 0
	if randf()>0.5: #1 out of 2 chances
		range = randf()*angle.x
	else:
		range = randf()*angle.y
	range *= frag_projectile_precision
	return range

func spawn_impact_wall_particles(emit_direction: float):
	var impact_particules : CPUParticles2D = bullet_impact_fragments_scene.instantiate()
	get_tree().current_scene.add_child(impact_particules)
	impact_particules.global_position = position
	impact_particules.rotation = emit_direction
	impact_particules.rotate(90)
	impact_particules.emitting = true

func handle_specific_collision(object: Object):
	if object.get_name() == "Walls":
		spawn_impact_wall_particles(self.rotation)

# Signals
func _on_life_cycle_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body == null:
		return
	
	if body is Character:
		current_piercing_force -= 1
	
	if body is Character and should_frag:
		var index : int = 0
		while index < number_of_frag_projectile:
			init_frag_bullet()
			index += 1
		queue_free()
	
	if (body.get_name() == "Walls" and should_pierce_walls) \
		or body.get_name().begins_with("ExplosiveBarrel"):
		current_piercing_force -= 1
	
	if body.has_method("handle_hit"):
		body.handle_hit(self, damages)
	if body.has_method("apply_force"):
		body.apply_force(body, self.direction, impact_force)
	
	if current_piercing_force <= 0:
		queue_free()


func _on_area_2d_body_exited(body):
	if body.get_name() == "Walls":
		spawn_impact_wall_particles(-self.rotation)


func _on_area_2d_area_entered(area):
	if area.get_name().begins_with("Door"):
		current_piercing_force -= 1
	if current_piercing_force <= 0:
		queue_free()

