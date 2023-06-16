extends Node
class_name PauseManager

@export var active : bool = false
@export var aim_blur_intensity : float = 1.0
@export var time_to_blur : float = 0.5

@export var pop_up_text_scene : PackedScene
@export var pop_up_contents : Array[String] = ["3", "2", "1", "Go !!!"]
@export var resume_pop_up_duration : float = 0.5
@export var resume_pop_up_scale := Vector2(5, 5)
@export var resume_pop_up_velocity_scale := Vector2(3, 3)

@export var choose_music_container : Container
@export var option_choose_playlist_label : Label
@export var option_choose_music_label : Label

@export var windows_resolution_label : Label
@export var screen_mode_state_label : Label
@export var screen_mode_checkbutton : CheckButton

@export var pause_gui : Node = null
@export var base_panel : Node = null
@export var option_panel : Node = null
@export var color_rect : Node = null

var gui_manager : GuiManager = null
var music_playlists_player : MusicPlaylistsPlayer
var current_blur_intensity : float = 0
var current_playlist_index : int = 0
var current_music_index : int = 0
var pop_up_timer : Timer = null
var disable_pause : bool = false


func _ready():
	gui_manager = get_parent() as GuiManager
	
	if GlobalVariables.playlists.keys().is_empty():
		return
	for playlist_name in GlobalVariables.playlists.keys():
		if GlobalVariables.current_playlist == playlist_name:
			break
		current_playlist_index += 1


func set_active(state: bool):
	if pause_gui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()


func _process(delta):
	if (active and current_blur_intensity < aim_blur_intensity) or (!active and current_blur_intensity > 0):
		color_rect.get_material().set_shader_parameter("intensity", current_blur_intensity)


func resume():
	base_panel.visible = false
	choose_music_container.visible = false
	gui_manager.cursor_manager.cursor.active_mode_idle_gui()
	gui_manager.set_active_gui_panels(true)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", 0, time_to_blur)
	if await start_resume_animation():
		GlobalFunctions.disable_all_game_objects(false)
		gui_manager.panel_timer_manager.resume_timer()
		set_active(false)


func generate_ui():
	display_base_panel()
	pause_gui.visible = true
	GlobalFunctions.disable_all_game_objects(true)
	gui_manager.cursor_manager.cursor.active_mode_ui()
	gui_manager.panel_timer_manager.stop_timer()
	gui_manager.set_active_gui_panels(false)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", aim_blur_intensity, time_to_blur)
	update_playlist_name()
	update_track_name()
	update_window_mode_ui()


func unload_ui():
	pause_gui.visible = false
	display_base_panel()
	color_rect.get_material().set_shader_parameter("intensity", 0)


func display_base_panel():
	base_panel.visible = true
	choose_music_container.visible = true
	option_panel.visible = false


func display_panel_option():
	option_panel.visible = true
	base_panel.visible = false
	choose_music_container.visible = false


func update_playlist_name():
	option_choose_playlist_label.text = music_playlists_player.current_playlist


func update_track_name():
	var current_track_name : String = GlobalVariables.playlists_track_names[music_playlists_player.current_playlist][music_playlists_player.current_track]
	option_choose_music_label.text = current_track_name


func update_window_mode_ui():
	var window_mode = DisplayServer.window_get_mode()
	
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		screen_mode_state_label.text = "(fullscreen)"
		screen_mode_checkbutton.button_pressed = true
	elif window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		screen_mode_state_label.text = "(windowed)"
		screen_mode_checkbutton.button_pressed = false


func instanciate_pop_up_text(content: String, duration: float, velocity_scale: Vector2) -> Timer:
	var pop_up_text_instance = pop_up_text_scene.instantiate()
	add_child(pop_up_text_instance)
	
	pop_up_text_instance.world_target = null
	pop_up_text_instance.scale = resume_pop_up_scale
	pop_up_text_instance.set_life_time(duration)
	pop_up_text_instance.velocity_scale = velocity_scale
	pop_up_text_instance.set_content(content)
	pop_up_text_instance.life_timer.start()
	return pop_up_text_instance.life_timer


func start_resume_animation() -> bool:
	var index : int = 0
	for pop_up_content in pop_up_contents:
		#last pop up will stay twice longer
		if index == pop_up_contents.size() -1:
			pop_up_timer = instanciate_pop_up_text(pop_up_content, resume_pop_up_duration * 2, resume_pop_up_velocity_scale / 2)
		else:
			pop_up_timer = instanciate_pop_up_text(pop_up_content, resume_pop_up_duration, resume_pop_up_velocity_scale)
		await pop_up_timer.timeout
		if pop_up_timer == null:
			return false
		index += 1
	pop_up_timer = null
	return true


func _unhandled_input(event):
	if event.is_action_pressed("echap"):
		if disable_pause:
			return
		if (!active and pop_up_timer == null) and (gui_manager.choose_weapon_manager.active and gui_manager.choose_weapon_manager.pop_up_timer != null):
			gui_manager.choose_weapon_manager.pop_up_timer = null
			gui_manager.choose_weapon_manager.set_active(false)
			set_active(true)
			return

		if !active or pop_up_timer != null:
			pop_up_timer = null
			set_active(true)
		elif base_panel.visible:
			resume()
		elif option_panel.visible:
			display_base_panel()


# Signals
func _on_resume_button_pressed():
	resume()


func _on_option_button_pressed():
	display_panel_option()


func _on_quit_button_pressed():
	GlobalFunctions.save()
	get_tree().quit()


func _on_switch_playlist_left_button_pressed():
	var playlists_names : Array = music_playlists_player.get_playlist_names()
	
	current_playlist_index += 1
	if current_playlist_index > playlists_names.size() - 1:
		current_playlist_index = 0
	
	var choosed_playlist : String = playlists_names[current_playlist_index]
	music_playlists_player.change_playlist(choosed_playlist, true, 2)
	update_playlist_name()
	update_track_name()


func _on_switch_playlist_right_button_pressed():
	var playlists_names : Array = music_playlists_player.get_playlist_names()
	
	current_playlist_index -= 1
	if current_playlist_index < 0:
		current_playlist_index = playlists_names.size() - 1
	
	var choosed_playlist : String = playlists_names[current_playlist_index]
	music_playlists_player.change_playlist(choosed_playlist, true, 2)
	update_playlist_name()
	update_track_name()


func _on_switch_music_left_button_pressed():
	music_playlists_player.next_track(true)
	update_track_name()


func _on_switch_music_right_button_pressed():
	music_playlists_player.next_track(true)
	update_track_name()


func _on_screen_mode_check_button_toggled(button_pressed: bool):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		update_window_mode_ui()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		update_window_mode_ui()


func _on_general_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_music_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_game_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), value)
