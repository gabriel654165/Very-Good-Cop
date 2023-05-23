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

func _unhandled_input(event):
	if event.is_action_pressed("switch_weapon_test"):
		await get_tree().create_timer(0.2).timeout
		set_weapon_panel_variables()

#call when weapon is switched
func set_weapon_panel_variables():
	var index : int = 0
	
	for weapon in GlobalVariables.all_distance_weapon_list:
		if index == GlobalVariables.index_distance_weapon_selected:
			panel_weapon.set_weapon_name(weapon.name)
			panel_weapon.weapon_texture.texture = weapon.gui_texture
			panel_weapon.reset_current_power_charger()
			
			#implem
			#ammo
			#reloading cooldown
			
			break
		index += 1

func handle_enemy_died(enemy: Node2D, points: int):
	panel_weapon.add_charge_power_bar(points)
