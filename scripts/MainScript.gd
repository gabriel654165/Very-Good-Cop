extends Node2D

@onready var bullet_manager = $BulletManager

func _ready():
	GlobalSignals.connect("bullet_fired_spawn", Callable(bullet_manager, "handle_bullet_spawned"))
