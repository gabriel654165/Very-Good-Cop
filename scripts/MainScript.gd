extends Node2D

@onready var projectile_manager = $ProjectileManager
#@onready var health_ui_manager = $HealthUiManager
@export var health_ui_manager : HealthUiManager

func _ready():
	GlobalSignals.connect("projectile_fired_spawn", Callable(projectile_manager, "handle_fired_projectile_spawned"))
	GlobalSignals.connect("projectile_launched_spawn", Callable(projectile_manager, "handle_launched_projectile_spawned"))

	GlobalSignals.connect("character_health_changed", Callable(health_ui_manager, "handle_character_health_changed"))	
	GlobalSignals.connect("character_max_health_changed", Callable(health_ui_manager, "handle_character_max_health_changed"))	
