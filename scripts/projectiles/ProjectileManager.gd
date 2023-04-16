extends Node2D
class_name ProjectileManager

#signal callback
func handle_fired_projectile_spawned(projectile_owner: Node2D, projectile: Projectile, position: Vector2, direction: Vector2):
	add_child(projectile)
	projectile.set_projectile_owner(projectile_owner)
	projectile.global_position = position
	projectile.set_direction(direction.normalized())

func handle_launched_projectile_spawned(projectile_owner: Node2D, grenade: Grenade, position: Vector2, direction: Vector2, landing_position: Vector2):
	add_child(grenade)
	grenade.set_projectile_owner(projectile_owner)
	grenade.global_position = position
	grenade.set_direction(direction.normalized())
	grenade.set_landing_position(landing_position)
	grenade.set_lauching_position(position)
	grenade.calulate_distance()

func handle_grappling_cable_drag(projectile_owner: Node2D, hook: GrapplingHook, projectile_position: Vector2, drag_speed: int):
	var distance = (projectile_owner.global_position - projectile_position).length()
	var duration = distance / drag_speed
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	await tween.tween_property(projectile_owner, "global_position", projectile_position, duration).finished
	hook.queue_free()
	if projectile_owner is Player: #or Character
		projectile_owner.hook_deployed = false
