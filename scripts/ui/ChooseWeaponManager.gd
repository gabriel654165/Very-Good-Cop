extends Node2D
class_name ChooseWeaponManager

@export var active : bool = false
@export var aim_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5

@export var choose_weapon_gui : Node = null
@export var base_panel : Node = null
@export var color_rect : Node = null

var gui_manager : GuiManager = null
var current_blur_intensity : float = 0

func _ready():
	gui_manager = get_parent() as GuiManager

func set_active(state: bool):
	if choose_weapon_gui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()

func generate_ui():
	pass

func unload_ui():
	pass
