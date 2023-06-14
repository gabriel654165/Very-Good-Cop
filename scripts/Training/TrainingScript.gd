extends Node2D
class_name TrainingScript

@onready var player = $Player
@onready var projectile_manager = $ProjectileManager
@onready var choose_weapon_manager = $CanvasLayer/ChooseWeaponManager
@onready var cursor_manager = $CanvasLayer/CursorManager


func _ready():
	GlobalSignals.projectile_fired_spawn.connect(projectile_manager.handle_fired_projectile_spawned)
	GlobalSignals.projectile_launched_spawn.connect(projectile_manager.handle_launched_projectile_spawned)
	GlobalSignals.grappling_cable_drag.connect(projectile_manager.handle_grappling_cable_drag)
	GlobalSignals.catching_cable_spawned.connect(projectile_manager.handle_catching_cable_spawned)
	
	GlobalSignals.play_sound.connect(_do_play_sound)
	
	cursor_manager.set_active(true)
	
	player.action_disabled = true
	choose_weapon_manager.color_rect.get_material().set_shader_parameter("intensity", choose_weapon_manager.aim_blur_intensity)
	choose_weapon_manager.current_blur_intensity = choose_weapon_manager.aim_blur_intensity
	cursor_manager.cursor.active_mode_ui()


func _unhandled_input(event):
	if event.is_action_pressed("echap"):
		get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")


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


func _on_start_button_pressed():
	player.action_disabled = false
	player.assign_weapons()
	
	choose_weapon_manager.base_panel.visible = false
	cursor_manager.cursor.active_mode_idle_gui()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(choose_weapon_manager, "current_blur_intensity", 0, choose_weapon_manager.time_to_blur)


func _input(event):
	if event.is_action_pressed("reload_level"):
		get_tree().reload_current_scene()

