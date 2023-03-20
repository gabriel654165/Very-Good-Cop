extends Node2D

@onready var player = $Player
@onready var bullet_manager = $BulletManager

func _ready():
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))
