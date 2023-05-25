extends Node2D
class_name ProjectileManager

#signal callback
func handle_fired_projectile_spawned(projectile_owner: Node2D, projectile: Projectile, position: Vector2, direction: Vector2):
	add_child(projectile)
	projectile.projectile_owner = projectile_owner
	projectile.global_position = position
	projectile.set_direction(direction.normalized())

func handle_launched_projectile_spawned(projectile_owner: Node2D, grenade: Grenade, position: Vector2, direction: Vector2, landing_position: Vector2):
	add_child(grenade)
	grenade.projectile_owner = projectile_owner
	grenade.global_position = position
	grenade.set_direction(direction.normalized())
	grenade.set_landing_position(landing_position)
	grenade.set_lauching_position(position)
	grenade.calulate_distance()

func handle_grappling_cable_drag(projectile_owner: Node2D, hook: GrapplingHook, projectile_position: Vector2, drag_speed: int):
	var distance = (projectile_owner.global_position - projectile_position).length()
	var duration = distance / drag_speed
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)

	# Small position safety
	var reduced_position = projectile_position - (projectile_position - projectile_owner.global_position).normalized() * distance * 0.025

	await tween.tween_property(projectile_owner, "global_position", reduced_position, duration).finished
	hook.queue_free()
	if projectile_owner is Player: #or Character
		projectile_owner.hook_deployed = false

func handle_catching_cable_spawned(projectile_owner: Node2D, catching_cable: CatchingCable, position: Vector2, shooting_direction: Vector2, expand_magnitude_factor: float):
	add_child(catching_cable)
	catching_cable.projectile_owner = projectile_owner
	catching_cable.global_position = position
	
	catching_cable.shooting_direction = shooting_direction
	var left_direction = shooting_direction
	var right_direction = shooting_direction
	if shooting_direction.normalized().x > 0.5 or shooting_direction.normalized().x < -0.5:
		# droite gauche
		left_direction.y += -1 if (shooting_direction.normalized().x > 0.5) else 1
		right_direction.y += 1 if (shooting_direction.normalized().x > 0.5) else -1
	if shooting_direction.normalized().y > 0.5 or shooting_direction.normalized().y < -0.5:
		# haut bas
		left_direction.x += 1 if (shooting_direction.normalized().y > 0.5) else -1
		right_direction.x += -1 if (shooting_direction.normalized().y > 0.5) else 1

	catching_cable.ball_left.set_direction(left_direction.normalized())
	catching_cable.ball_right.set_direction(right_direction.normalized())
