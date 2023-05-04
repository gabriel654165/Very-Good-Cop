extends Node

@export var active : bool = false
@export var aim_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5

@export var pop_up_text_scene : PackedScene
@export var pop_up_contents : Array[String] = ["3", "2", "1", "Go fuck some bitches !!!"]
@export var resume_pop_up_duration : float = 0.5
@export var resume_pop_up_scale := Vector2(5, 5)
@export var resume_pop_up_velocity_scale := Vector2(3, 3)

@export var pause_gui : Node = null
@export var base_panel : Node = null
@export var option_panel : Node = null
@export var color_rect : Node = null

var gui_manager : GuiManager = null
var characters_in_scene : Array = []
var current_blur_intensity : float = 0
var pop_up_timer : Timer = null

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
	if (active and current_blur_intensity < 1) or (!active and current_blur_intensity > 0):
		color_rect.get_material().set_shader_parameter("intensity", current_blur_intensity)
	
	#trouver un moyen de pas appeler ca en boucle
	elif !active and current_blur_intensity == 0:
		#print("resume")
		pause_gui.visible = false
		display_base_panel()

func resume_flow():
	unload_ui()
	gui_manager.cursor_manager.cursor.active_mode_idle_gui()	
	start_resume_animation()

func generate_ui():
	display_base_panel()
	pause_gui.visible = true
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is Character, characters_in_scene, get_tree().root)
	disable_in_game_objects(true)
	gui_manager.cursor_manager.cursor.active_mode_ui()
	set_active_gui_panels(false)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", aim_blur_intensity, time_to_blur)

func unload_ui():
	base_panel.visible = false
	gui_manager.panel_points_manager.panel.visible = true
	gui_manager.panel_kills_manager.panel.visible = true
	gui_manager.panel_timer_manager.panel.visible = true
	gui_manager.weapon_panel_manager.panel_weapon.visible = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", 0, time_to_blur)

func set_active_gui_panels(state: bool):
	gui_manager.panel_points_manager.panel.visible = state
	gui_manager.panel_kills_manager.panel.visible = state
	gui_manager.panel_timer_manager.panel.visible = state
	gui_manager.weapon_panel_manager.panel_weapon.visible = state

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

func start_resume_animation():
	var index : int = 0
	for pop_up_content in pop_up_contents:
		#last pop up will stay longer
		if index == pop_up_contents.size() -1:
			pop_up_timer = instanciate_pop_up_text(pop_up_content, resume_pop_up_duration * 2, resume_pop_up_velocity_scale / 2)
		else:
			pop_up_timer = instanciate_pop_up_text(pop_up_content, resume_pop_up_duration, resume_pop_up_velocity_scale)
		await pop_up_timer.timeout
		if pop_up_timer == null:
			return
		index += 1
	pop_up_timer = null
	disable_in_game_objects(false)
	set_active(false)

func _unhandled_input(event):
	if event.is_action_pressed("echap"):
		if !active or pop_up_timer != null:
			pop_up_timer = null
			set_active(true)
		elif base_panel.visible:
			resume_flow()
		elif option_panel.visible:
			display_base_panel()

func disable_in_game_objects(state: bool):
	var index : int = 1
	for character in characters_in_scene:
		if character != null:
			character.action_disabled = state
		else:
			characters_in_scene.remove_at(index)
			continue
		index += 1

# Signals
func _on_resume_button_pressed():
	resume_flow()

func _on_option_button_pressed():
	display_panel_option()

func _on_quit_button_pressed():
	get_tree().quit()