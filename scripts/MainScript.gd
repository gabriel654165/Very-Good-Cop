extends Node2D

@export var gui_manager_scene : PackedScene
@export var projectile_manager_scene : PackedScene

var gui_manager : GuiManager
var projectile_manager : ProjectileManager

func _ready():
	instanciate_objects_managers()
	
	GlobalSignals.connect("projectile_fired_spawn", Callable(projectile_manager, "handle_fired_projectile_spawned"))
	GlobalSignals.connect("projectile_launched_spawn", Callable(projectile_manager, "handle_launched_projectile_spawned"))
	GlobalSignals.connect("grappling_cable_drag", Callable(projectile_manager, "handle_grappling_cable_drag"))
	
	GlobalSignals.connect("character_health_changed", Callable(gui_manager.health_ui_manager, "handle_character_health_changed"))	
	GlobalSignals.connect("character_max_health_changed", Callable(gui_manager.health_ui_manager, "handle_character_max_health_changed"))	

func instanciate_objects_managers():
	gui_manager = gui_manager_scene.instantiate()
	projectile_manager = projectile_manager_scene.instantiate()
	
	add_child(gui_manager)
	add_child(projectile_manager)
