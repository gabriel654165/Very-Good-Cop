extends Node2D

#signal callback
func handle_fired_projectile_spawned(projectile: Projectile, position: Vector2, direction: Vector2):
	add_child(projectile)
	projectile.global_position = position
	projectile.set_direction(direction.normalized())

func handle_launched_projectile_spawned(grenade: Grenade, position: Vector2, direction: Vector2, landing_position: Vector2):
	add_child(grenade)
	grenade.global_position = position
	grenade.set_direction(direction.normalized())
	grenade.set_landing_position(landing_position)
	grenade.set_lauching_position(position)
	grenade.calulate_distance()

# Weapon -> ThrowableWeapon

# ThrowableWeapon
#      Projectile ThrownWeapon
#	func throw()
#		ThrownWeapon.instantiate()
		
