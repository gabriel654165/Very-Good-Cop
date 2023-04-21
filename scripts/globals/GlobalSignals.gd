extends Node

signal player_fired()

signal projectile_fired_spawn(projectile_owner: Node2D, projectile: Projectile, position: Vector2, direction: Vector2)
signal projectile_launched_spawn(projectile_owner: Node2D, grenade: Grenade, position: Vector2, direction: Vector2, landing_position: Vector2)
signal grappling_cable_drag(projectile_owner: Node2D, hook: GrapplingHook, projectile_position: Vector2, drag_speed: int)

signal character_health_changed(health: Health, value: float)
signal character_max_health_changed(health: Health, value: float)

signal enemy_died(enemy: Node2D, points: int)
