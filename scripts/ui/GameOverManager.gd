extends Node2D

@export var active : bool = false
@export var game_over_gui : Node = null
@export var animation_player : AnimationPlayer
@export var buttons_container : Node
@export var time_before_display : float = 2

var gui_manager : GuiManager = null

func _ready():
	gui_manager = get_parent() as GuiManager

func set_active(state: bool):
	if game_over_gui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()

func generate_ui():
	await get_tree().create_timer(time_before_display).timeout
	game_over_gui.visible = true
	gui_manager.set_active_gui_panels(false)
	gui_manager.cursor_manager.cursor.active_mode_ui()
	gui_manager.pause_manager.disable_pause = true
	animation_player.play("game_over_on")

func unload_ui():
	game_over_gui.visible = false

func restart():
	get_tree().reload_current_scene()

func _on_resart_button_pressed():
	GlobalVariables.level = 0
	GlobalVariables.money = 0
	GlobalVariables.index_distance_weapon_selected = 0
	GlobalVariables.index_melee_weapon_selected = 0
	GlobalFunctions.reset_distance_weapon_levels()
	GlobalFunctions.reset_melee_weapon_levels()
	GlobalFunctions.reset_equipment_levels()
	animation_player.play("game_over_off")

func _on_quit_button_pressed():
	get_tree().quit()
