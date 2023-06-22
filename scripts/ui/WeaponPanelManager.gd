extends Node2D
class_name PowerChargeBarManager

@export var weapon_panel_gui : PackedScene
@export var panels_container : Control

var panel_distance_weapon : PanelWeaponGui
var panel_melee_weapon : PanelWeaponGui
var panel_throwable_object : PanelWeaponGui

var player : Player

func _ready():
	player = GlobalFunctions.find_object_on_condition(func(elem: Node): return elem is Player, get_tree().root)
	if player == null:
		return
	if player.weapon_manager == null:
		return
	if player.weapon_manager.weapon == null:
		return
	
	panel_distance_weapon = weapon_panel_gui.instantiate()
	panels_container.add_child(panel_distance_weapon)
	panel_melee_weapon = weapon_panel_gui.instantiate()
	panels_container.add_child(panel_melee_weapon)
	panel_throwable_object = weapon_panel_gui.instantiate()
	panels_container.add_child(panel_throwable_object)
	set_weapon_panel_variables()

func set_active_panels(state: bool):
	panel_distance_weapon.visible = state
	panel_melee_weapon.visible = state
	panel_throwable_object.visible = state

# Call when weapon is switched
func set_weapon_panel_variables():
	#redondant
	var index : int = 0
	for weapon in GlobalVariables.all_distance_weapon_list:
		if index == GlobalVariables.index_distance_weapon_selected:
			panel_distance_weapon.set_weapon_name(weapon.name)
			panel_distance_weapon.weapon_texture.texture = weapon.gui_texture
			for stat_dictionnary in weapon.stats:
				if ("ammo_size" in stat_dictionnary):
					var stat = stat_dictionnary["ammo_size"]
					var current_lvl = GlobalVariables.player_distance_weapon_list[index].ammo_size_lvl
					var ammo_size : int = GlobalFunctions.linear_ratio(stat.min_value, stat.max_value, stat.number_of_levels, current_lvl, 0)
					panel_distance_weapon.set_ammo_size(ammo_size)
				if "points_to_use_special_power" in stat_dictionnary:
					var stat = stat_dictionnary["points_to_use_special_power"]
					var current_lvl = GlobalVariables.player_distance_weapon_list[index].points_to_use_special_power_lvl
					var points_to_use_special_power : int = GlobalFunctions.linear_ratio(stat.min_value, stat.max_value, stat.number_of_levels, current_lvl, 0)
					if GlobalVariables.player_distance_weapon_list[GlobalVariables.index_distance_weapon_selected].special_power_unlocked:
						panel_distance_weapon.set_power_aim_value(points_to_use_special_power)
			break
		index += 1
	
	#redondant
	index = 0
	for weapon in GlobalVariables.all_melee_weapon_list:
		if index == GlobalVariables.index_melee_weapon_selected:
			panel_melee_weapon.set_weapon_name(weapon.name)
			panel_melee_weapon.weapon_texture.texture = weapon.gui_texture
			for stat_dictionnary in weapon.stats:
				if "points_to_use_special_power" in stat_dictionnary:
					var stat = stat_dictionnary["points_to_use_special_power"]
					var current_lvl = GlobalVariables.player_melee_weapon_list[index].points_to_use_special_power_lvl
					var points_to_use_special_power : int = GlobalFunctions.linear_ratio(stat.min_value, stat.max_value, stat.number_of_levels, current_lvl, 0)
					if GlobalVariables.player_melee_weapon_list[GlobalVariables.index_melee_weapon_selected].special_power_unlocked:
						panel_melee_weapon.set_power_aim_value(points_to_use_special_power)
			break
		index += 1
	
	#redondant
	index = 0
	for projectile in GlobalVariables.all_throwable_object_list:
		if index == GlobalVariables.index_throwable_object_selected:
			panel_throwable_object.set_weapon_name(projectile.name)
			panel_throwable_object.weapon_texture.texture = projectile.gui_texture
			for stat_dictionnary in projectile.stats:
				if ("ammo_size" in stat_dictionnary):
					var stat = stat_dictionnary["ammo_size"]
					var current_lvl = GlobalVariables.player_throwable_object_list[index].ammo_size_lvl
					var ammo_size : int = GlobalFunctions.linear_ratio(stat.min_value, stat.max_value, stat.number_of_levels, current_lvl, 0)
					panel_throwable_object.set_ammo_size(ammo_size)
			break
		index += 1


# Signal callback
func handle_player_fired():
	panel_distance_weapon.update_ammo_on_fire()

func handle_player_reload(reload_time: float):
	panel_distance_weapon.update_ammo_on_reload(reload_time)

func handle_enemy_died(enemy: Node2D, points: int):
	panel_distance_weapon.update_special_power_on_kill(points)

func handle_use_special_power():
	panel_distance_weapon.update_special_power_on_use()

func handle_throwed_object():
	panel_throwable_object.update_ammo_on_fire()
