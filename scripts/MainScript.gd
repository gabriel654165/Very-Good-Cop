extends Node2D

@export var gui_manager_scene : PackedScene
@export var projectile_manager_scene : PackedScene
@export var level_generator_scene : PackedScene

@onready var gui_manager : GuiManager = add_manager(gui_manager_scene)
@onready var projectile_manager : ProjectileManager = add_manager(projectile_manager_scene)
@onready var level_generator: LevelGenerator = add_manager(level_generator_scene)

@onready var player : Player = $Player

func _ready():
	GlobalSignals.player_fired.connect(gui_manager.cursor_manager.active_mode_hit_marker_gui)
	
	GlobalSignals.projectile_fired_spawn.connect(projectile_manager.handle_fired_projectile_spawned)
	GlobalSignals.projectile_launched_spawn.connect(projectile_manager.handle_launched_projectile_spawned)
	GlobalSignals.grappling_cable_drag.connect(projectile_manager.handle_fired_projectile_spawned)
	
	GlobalSignals.character_health_changed.connect(gui_manager.health_ui_manager.handle_character_health_changed)
	GlobalSignals.character_health_changed.connect(gui_manager.pop_up_health_manager.handle_character_health_changed)
	GlobalSignals.character_max_health_changed.connect(gui_manager.health_ui_manager.handle_character_max_health_changed)
	
	GlobalSignals.enemy_died.connect(player.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.pop_up_points_manager.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.panel_points_manager.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.panel_kills_manager.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.weapon_panel_manager.handle_enemy_died)

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

func _input(event):
	if event.is_action_pressed("reload_level_test"):
		get_tree().reload_current_scene()
