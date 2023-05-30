extends Node2D
class_name MainScript

@export var gui_manager_scene : PackedScene
@export var projectile_manager_scene : PackedScene
@export var level_generator_scene : PackedScene
@export var player : Player

@export var colorect_chromatic : ColorRect
@export var colorect_redialdistortion : ColorRect
@export var colorect_distortion : ColorRect

@onready var gui_manager : GuiManager = add_manager(gui_manager_scene, self, func(x):pass)
@onready var projectile_manager : ProjectileManager = add_manager(projectile_manager_scene, self, func(x):pass)
@onready var level_generator: LevelGenerator = add_manager(level_generator_scene, self, func(x):pass)
@onready var camera : Camera2D = $MainCamera


func _ready():
	GlobalSignals.player_fired.connect(gui_manager.cursor_manager.hit_marker_action)

	GlobalSignals.play_sound.connect(_do_play_sound)

	GlobalSignals.projectile_fired_spawn.connect(projectile_manager.handle_fired_projectile_spawned)
	GlobalSignals.projectile_launched_spawn.connect(projectile_manager.handle_launched_projectile_spawned)
	GlobalSignals.grappling_cable_drag.connect(projectile_manager.handle_grappling_cable_drag)
	GlobalSignals.catching_cable_spawned.connect(projectile_manager.handle_catching_cable_spawned)
	
	GlobalSignals.character_health_changed.connect(gui_manager.health_ui_manager.handle_character_health_changed)
	GlobalSignals.character_health_changed.connect(gui_manager.pop_up_health_manager.handle_character_health_changed)
	GlobalSignals.character_max_health_changed.connect(gui_manager.health_ui_manager.handle_character_max_health_changed)

	GlobalSignals.enemy_died.connect(player.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.pop_up_points_manager.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.panel_points_manager.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.panel_kills_manager.handle_enemy_died)
	GlobalSignals.enemy_died.connect(gui_manager.weapon_panel_manager.handle_enemy_died)
	
	GlobalSignals.active_minimap_power_up.connect(_set_minimap_power_up)
	GlobalSignals.active_slowmotion_power_up.connect(_set_slowmotion_power_up)
	GlobalSignals.active_speed_power_up.connect(_set_speed_power_up)
	GlobalSignals.active_damage_power_up.connect(_set_damage_power_up)
	GlobalSignals.active_heal_power_up.connect(_set_heal_power_up)

	if level_generator != null:
		await level_generator.generate()
	spawn_player()
	init_camera()
	gui_manager.generate_ui()


# TODO : animation of heal and after visible = false, enable not needed
func _set_heal_power_up(enable: bool):
	pass

func _set_damage_power_up(enable: bool):
	pass

func _set_speed_power_up(enable: bool):
	colorect_redialdistortion.visible = enable

func _set_slowmotion_power_up(enable: bool):
	colorect_distortion.visible = enable

# TODO : display entiere minimap with arrival room
func _set_minimap_power_up(enable: bool):
	colorect_chromatic.visible = enable


# NOTE: Should we put an autoload function or keep it as a signal ? (https://github.com/godotengine/godot-proposals/issues/1827)
func _do_play_sound(sound:AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0, pos:Vector2i = player.global_position):
	var audio_stream_player := AudioStreamPlayer2D.new()
	add_child(audio_stream_player)
	audio_stream_player.bus = "Sounds"
	audio_stream_player.stream = sound
	audio_stream_player.volume_db = volume_db * 10
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.global_position = pos
	audio_stream_player.play()
	
	audio_stream_player.finished.connect(audio_stream_player.queue_free)


func spawn_player():
	if level_generator != null:
		player.global_position = level_generator.local_to_world_position(level_generator.entrance_pos)


func init_camera():
	camera.global_position = player.global_position


func add_manager(packed_manager:PackedScene, parent: Node, init_func:Callable=func(x):pass):
	if packed_manager == null:
		return
	var manager = packed_manager.instantiate()
	parent.add_child(manager)
	
	init_func.call(manager)

	return manager

#debug
func _input(event):
	if event.is_action_pressed("reload_level_test"):
		get_tree().reload_current_scene()
