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

#call when weapon is switched
func set_weapon_panel_variables():
	panel_weapon.set_weapon_name(player.weapon_manager.weapon.weapon_name)
	panel_weapon.set_level_value("lvl-" + str(player.weapon_manager.weapon.level))
	panel_weapon.set_weapon_sprite(player.weapon_manager.weapon.side_sprite)
	panel_weapon.reset_current_power_charger()

func handle_enemy_died(enemy: Node2D, points: int):
	panel_weapon.add_charge_power_bar(points)
