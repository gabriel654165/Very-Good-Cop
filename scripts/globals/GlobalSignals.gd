extends Node

signal projectile_fired_spawn(projectile_owner, projectile, position, direction)
signal projectile_launched_spawn(projectile_owner, grenade, position, direction, landing_position)
signal grappling_cable_drag(projectile_owner, hook, projectile_position, drag_speed)

signal character_health_changed(health, value)
signal character_max_health_changed(health, value)

#signal bullet_fired_force(character, direction, force)
