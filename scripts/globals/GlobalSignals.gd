extends Node

signal projectile_fired_spawn(projectile, position, direction)
signal projectile_launched_spawn(projectile, position, direction, landing_position)

signal character_health_changed(health, value)
signal character_max_health_changed(health, value)

#signal bullet_fired_force(character, direction, force)
