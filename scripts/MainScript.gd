extends Node2D

@export var gui_manager_scene : PackedScene
@export var projectile_manager_scene : PackedScene
@export var level_generator_scene : PackedScene

@onready var gui_manager : GuiManager = add_manager(gui_manager_scene)
@onready var projectile_manager : ProjectileManager = add_manager(projectile_manager_scene)
@onready var level_generator: LevelGenerator = add_manager(level_generator_scene)

#@onready var camera : Camera2D = $Camera2D
#@onready var remote_transform : RemoteTransform2D = $RemoteTransform2D
@onready var player : Player = $Player

func _ready():
	GlobalSignals.connect("player_fired", Callable(gui_manager.cursor_manager, "active_mode_hit_marker_gui"))
	
	GlobalSignals.connect("projectile_fired_spawn", Callable(projectile_manager, "handle_fired_projectile_spawned"))
	GlobalSignals.connect("projectile_launched_spawn", Callable(projectile_manager, "handle_launched_projectile_spawned"))
	GlobalSignals.connect("grappling_cable_drag", Callable(projectile_manager, "handle_grappling_cable_drag"))
	#GlobalSignals.grappling_cable_drag.connect(projectile_manager.handle_fired_projectile_spawned)
	
	GlobalSignals.connect("character_health_changed", Callable(gui_manager.health_ui_manager, "handle_character_health_changed"))
	GlobalSignals.connect("character_health_changed", Callable(gui_manager.pop_up_health_manager, "handle_character_health_changed"))
	GlobalSignals.connect("character_max_health_changed", Callable(gui_manager.health_ui_manager, "handle_character_max_health_changed"))
	
	GlobalSignals.connect("enemy_died", Callable(player, "handle_enemy_died"))
	GlobalSignals.connect("enemy_died", Callable(gui_manager.pop_up_points_manager, "handle_enemy_died"))
	GlobalSignals.connect("enemy_died", Callable(gui_manager.panel_points_manager, "handle_enemy_died"))
	GlobalSignals.connect("enemy_died", Callable(gui_manager.panel_kills_manager, "handle_enemy_died"))
	GlobalSignals.connect("enemy_died", Callable(gui_manager.weapon_panel_manager, "handle_enemy_died"))

	await level_generator.generate()
	spawn_player()
	gui_manager.generateUi()

func spawn_player():
	player.position = level_generator.local_to_world_position(level_generator.entrance_pos)

func add_manager(packed_manager:PackedScene, init_func:Callable=func(x):pass):
	var manager = packed_manager.instantiate()
	add_child(manager)
	
	init_func.call(manager)

	return manager
