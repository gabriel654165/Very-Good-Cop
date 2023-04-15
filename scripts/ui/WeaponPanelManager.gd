extends Node2D
class_name PowerChargeBarManager

@export var weapon_panel_gui : PackedScene
@export var panels_container : Control

var panel_weapon : PanelWeaponGui
var player : Player

func _ready():
	player = GlobalFunctions.find_object_on_condition(func(elem: Node): return elem is Player, get_tree().root)
	if player == null:
		return
	if player.weapon_manager == null:
		return
	if player.weapon_manager.weapon == null:
		return
	
	panel_weapon = weapon_panel_gui.instantiate()
	panels_container.add_child(panel_weapon)
	set_weapon_panel_variables()

# TEST switch weapon
func _unhandled_input(event):
	if event.is_action_pressed("test"):
		await get_tree().create_timer(0.2).timeout
		set_weapon_panel_variables()

#call when weapon is switched
func set_weapon_panel_variables():
	
	#ne pas prendre de la save...
	panel_weapon.set_weapon_name(GlobalVariables.all_weapon_scene_list[GlobalVariables.index_weapon_selected].name)
	panel_weapon.set_level_value("lvl" + str(1))
	#!ne pas prendre de la save...
	
	panel_weapon.set_weapon_sprite(player.weapon_manager.weapon.side_sprite)
	panel_weapon.reset_current_power_charger()

func handle_enemy_died(enemy: Enemy, points: int):
	panel_weapon.add_charge_power_bar(points)
	print("power charger = ", panel_weapon.current_power_charger)
