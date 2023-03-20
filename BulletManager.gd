extends Node2D

@onready var player = $Player
@onready var bullet_manager = $BulletManager

#signal
func handle_bullet_spawned(bullet: Bullet, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
