extends Node

@export var active : bool = false
@export var game_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5

@export var pause_gui : Node = null
@export var base_panel : Node = null
@export var option_panel : Node = null
@export var color_rect : Node = null

var gui_manager : GuiManager = null
var characters_in_scene : Array = []

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

var blur_intensity : float = 0

func _process(delta):
	if (active and blur_intensity < 1) or (!active and blur_intensity > 0):
		color_rect.get_material().set_shader_parameter("intensity", blur_intensity)
	#trouver un moyen de pas appeler ca en boucle
	elif !active and blur_intensity <= 0:
		pause_gui.visible = false
		display_base_panel()
		resume_game()

func generate_ui():
	display_base_panel()
	pause_gui.visible = true
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is Character, characters_in_scene, get_tree().root)
	for character in characters_in_scene:
		character.action_disabled = true
	gui_manager.cursor_manager.cursor.active_mode_ui()
	
	gui_manager.panel_points_manager.panel.visible = false
	gui_manager.panel_kills_manager.panel.visible = false
	gui_manager.panel_timer_manager.panel.visible = false
	gui_manager.weapon_panel_manager.panel_weapon.visible = false
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "blur_intensity", game_blur_intensity, time_to_blur)

func unload_ui():
	base_panel.visible = false
	gui_manager.cursor_manager.cursor.active_mode_idle_gui()
	
	gui_manager.panel_points_manager.panel.visible = true
	gui_manager.panel_kills_manager.panel.visible = true
	gui_manager.panel_timer_manager.panel.visible = true
	gui_manager.weapon_panel_manager.panel_weapon.visible = true
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "blur_intensity", 0, time_to_blur)

func _unhandled_input(event):
	if event.is_action_pressed("echap"):
		if !active:
			set_active(true)
		elif base_panel.visible:
			set_active(false)
		elif option_panel.visible:
			display_base_panel()

func resume_game():
	var index : int = 1
	for character in characters_in_scene:
		if character != null:
			character.action_disabled = false
			characters_in_scene.remove_at(index)
			continue
	index += 1
	#pop up text GO !!!

func display_base_panel():
	base_panel.visible = true
	option_panel.visible = false

func display_panel_option():
	option_panel.visible = true
	base_panel.visible = false

# Signals
func _on_resume_button_pressed():
	set_active(false)

func _on_option_button_pressed():
	display_panel_option()

func _on_quit_button_pressed():
	get_tree().quit()
