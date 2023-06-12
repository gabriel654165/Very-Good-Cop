extends Node2D

@export var gui_manager_scene : PackedScene
@export var screen_effects_manager_scene : PackedScene
@export var projectile_manager_scene : PackedScene
@export var level_generator_scene : PackedScene

@onready var player : Player = $Player
@onready var camera : Camera2D = $MainCamera
@onready var music_playlists_player : MusicPlaylistsPlayer = $MusicPlaylistsPlayer
@onready var gui_manager : GuiManager = add_manager(gui_manager_scene, self, func(x):pass)
@onready var screen_effects_manager : ScreenEffectManager = add_manager(screen_effects_manager_scene, camera, func(x):pass)
@onready var projectile_manager : ProjectileManager = add_manager(projectile_manager_scene, self, func(x):pass)
@onready var level_generator: LevelGenerator = add_manager(level_generator_scene, self, func(x):pass)

@onready var minimap : Minimap = Minimap.new()
@onready var level_difficulty : LevelDifficulty = LevelDifficulty.new()

func _ready():
	GlobalSignals.assign_player_weapons.connect(player.assign_weapons)
	
	GlobalSignals.player_fired.connect(gui_manager.cursor_manager.hit_marker_action)
	GlobalSignals.player_fired.connect(gui_manager.weapon_panel_manager.handle_player_fired)
	GlobalSignals.player_reloading.connect(gui_manager.weapon_panel_manager.handle_player_reload)
	GlobalSignals.player_use_special_power.connect(gui_manager.weapon_panel_manager.handle_use_special_power)
	
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
	
	GlobalSignals.power_up_taken.connect(gui_manager.panel_power_ups_manager.handle_power_up_taken)
	GlobalSignals.power_up_taken.connect(gui_manager.pop_up_power_up_manager.handle_power_up_taken)
	
	GlobalSignals.interaction_computed.connect(gui_manager.pop_up_interaction_manager.handle_interaction_computed)
	
	GlobalSignals.active_minimap_power_up.connect(screen_effects_manager.set_minimap_power_up)
	GlobalSignals.active_minimap_power_up.connect(gui_manager.minimap_manager.handle_minimap_power_up)
	GlobalSignals.active_slowmotion_power_up.connect(screen_effects_manager.set_slowmotion_power_up)
	GlobalSignals.active_speed_power_up.connect(screen_effects_manager.set_speed_power_up)
	GlobalSignals.active_damage_power_up.connect(screen_effects_manager.set_damage_power_up)
	GlobalSignals.active_heal_power_up.connect(screen_effects_manager.set_heal_power_up)

	GlobalSignals.map_updated.connect(gui_manager.minimap_manager.update)
	GlobalSignals.map_updated.connect(level_difficulty.update_difficulty)
	GlobalSignals.game_over.connect(gui_manager.game_over_manager.generate_ui)

	if level_generator != null:
		await level_generator.generate()

		minimap.init(player, level_generator, self)
		minimap.load_map(level_generator.dungeon_layout.duplicate())
		add_child(minimap)
		
		level_difficulty.init(player, minimap)
		add_child(level_difficulty)
		
		gui_manager.minimap_manager.minimap_inst = minimap
		gui_manager.recap_level_manager.level_difficulty_inst = level_difficulty

	spawn_player()
	init_camera()
	
	if gui_manager != null:
		gui_manager.player_ref = player
		gui_manager.generate_ui()
	
	if music_playlists_player != null:
		gui_manager.pause_manager.music_playlists_player = music_playlists_player
	


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
