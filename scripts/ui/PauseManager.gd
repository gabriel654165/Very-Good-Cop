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

@export var pause_gui : Node = null
@export var base_panel : Node = null
@export var option_panel : Node = null
@export var color_rect : Node = null

var gui_manager : GuiManager = null
var current_blur_intensity : float = 0
var pop_up_timer : Timer = null
var disable_pause : bool = false

func _ready():
	gui_manager = get_parent() as GuiManager

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

func unload_ui():
	pause_gui.visible = false
	display_base_panel()
	color_rect.get_material().set_shader_parameter("intensity", 0)

func display_base_panel():
	base_panel.visible = true
	option_panel.visible = false

func display_panel_option():
	option_panel.visible = true
	base_panel.visible = false

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
	return
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
	get_tree().quit()
