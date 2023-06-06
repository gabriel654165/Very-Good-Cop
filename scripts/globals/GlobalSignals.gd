extends Node

signal assign_player_weapons()

signal player_fired()
signal player_reloading(ammo_reloading_time: float)
signal player_use_special_power()

signal weapon_shoot(projectile_owner: Node2D)
signal projectile_fired_spawn(projectile_owner: Node2D, projectile: Projectile, position: Vector2, direction: Vector2)
signal projectile_launched_spawn(projectile_owner: Node2D, grenade: Grenade, position: Vector2, direction: Vector2, landing_position: Vector2)
signal grappling_cable_drag(projectile_owner: Node2D, hook: GrapplingHook, projectile_position: Vector2, drag_speed: int)
signal catching_cable_spawned(projectile_owner: Node2D, catching_cable: CatchingCable, position: Vector2, shooting_direction: Vector2, expand_magnitude_factor: float)

signal play_sound(sound:AudioStream, volume_db:float, pitch_scale:float, pos:Vector2i)

signal character_health_changed(health: Health, value: float)
signal character_max_health_changed(health: Health, value: float)

signal enemy_died(enemy: Node2D, points: int)

signal level_generated(player_position: Vector2)

signal active_minimap_power_up(enable: bool)
signal active_slowmotion_power_up(enable: bool)
signal active_speed_power_up(enable: bool)
signal active_damage_power_up(enable: bool)
signal active_heal_power_up(enable: bool)

signal sound_emitted(source: Node2D, location: Vector2, intensity: float)

signal map_updated()
signal game_over()
