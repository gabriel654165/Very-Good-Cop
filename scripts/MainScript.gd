extends Node2D

@export var gui_manager_scene : PackedScene
@export var projectile_manager_scene : PackedScene
@export var level_generator_scene : PackedScene

const PackedPlayer : PackedScene = preload("res://scenes/characters/player.tscn")
var player: Player

@onready var gui_manager : GuiManager = add_manager(gui_manager_scene)
@onready var projectile_manager : ProjectileManager = add_manager(projectile_manager_scene)
@onready var level_generator: LevelGenerator = add_manager(level_generator_scene)


func _ready():
	GlobalSignals.connect("projectile_fired_spawn", Callable(projectile_manager, "handle_fired_projectile_spawned"))
	GlobalSignals.connect("projectile_launched_spawn", Callable(projectile_manager, "handle_launched_projectile_spawned"))
#	GlobalSignals.connect("grappling_cable_drag", Callable(projectile_manager, "handle_grappling_cable_drag"))

	GlobalSignals.connect("projectile_launched_spawn", Callable(projectile_manager, "handle_launched_projectile_spawned"))

	GlobalSignals.grappling_cable_drag.connect(projectile_manager.handle_fired_projectile_spawned)

	GlobalSignals.connect("character_health_changed", Callable(gui_manager.health_ui_manager, "handle_character_health_changed"))	
	#signal gui -X health
	GlobalSignals.connect("character_max_health_changed", Callable(gui_manager.health_ui_manager, "handle_character_max_health_changed"))	

#	GlobalSignals.connect("enemy_died", Callable(player, "handle_enemy_died"))
	#GlobalSignals.connect("enemy_died", Callable(gui_manager.pop_up_points_ui_manager, "handle_enemy_died"))
	#GlobalSignals.connect("enemy_died", Callable(gui_manager.text_points_ui_manager, "handle_enemy_died"))
	#GlobalSignals.connect("enemy_died", Callable(gui_manager.power_charge_bar_ui_manager, "handle_enemy_died"))
	level_generator.generate()
	spawn_player()
	$Camera2D.position = player.position


func spawn_player():
	player = PackedPlayer.instantiate()
	add_child(player)
	player.position = level_generator.local_to_world_position(level_generator.entrance_pos)


func add_manager(packed_manager:PackedScene, init_func:Callable=func(x):pass):
	var manager = packed_manager.instantiate()
	add_child(manager)
	
	init_func.call(manager)

	return manager
