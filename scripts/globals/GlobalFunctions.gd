extends Node

func _ready():
	init_global_variables()
	randomize()
	
	print_func_time(
		Callable(LevelGenerator, "load_all_rooms_from").bind("res://scenes/rooms/"), # Just fancy stuff to use bind on a static func, I could also make a lambda where I call the function with the argument
		"Loaded every room"
	)


func init_global_variables():
	GlobalVariables.rooms_repository.resize(0b1111 + 1) # All 4 doors in a room is represented as 0b1111 (bitflag) + make up the fact that we want the number of numbers from 0 to 0b1111 so +1


func get_speed(delta: float, speed: float) -> float:
	return speed * (delta * 60)


func is_inside_vector_2(aim_pos: Vector2, src_pos: Vector2, offset: Vector2):
	var upper_y : float = aim_pos.y + offset.y
	var down_y : float = aim_pos.y - offset.y
	var upper_x : float = aim_pos.x + offset.x
	var down_x : float = aim_pos.x - offset.x
	
	var is_under_offset_y : bool = src_pos.y < upper_y
	var is_upper_offset_y : bool = src_pos.y > down_y
	var is_under_offset_x : bool = src_pos.x < upper_x
	var is_upper_offset_x : bool = src_pos.x > down_x
	
	if is_under_offset_y and is_upper_offset_y and is_under_offset_x and is_upper_offset_x:
		return true
	return false


func append_in_array_on_condition(condition: Callable, array: Array, parent: Node):
	for child in parent.get_children():
		if condition.call(child):
			array.append(child)
		if child.get_child_count() > 0:
			append_in_array_on_condition(condition, array, child)
	return


func find_object_on_condition(condition: Callable, parent: Node) -> Node:
	var object : Node = null
	
	for child in parent.get_children():
		if condition.call(child):
			object = child
			break
		if child.get_child_count() > 0:
			object = find_object_on_condition(condition, child)
	return object


func print_func_time(fn:Callable, message:=fn.get_method()):
	var t = Time.get_unix_time_from_system()

	fn.call()
	
	prints(message, "in", Time.get_unix_time_from_system() - t, "seconds")


# WARNING : PAS DE DIVISION / 0
# WARNING : CURRENT_LVL > TOTAL_LVL == NON
func linear_ratio(min_val, max_val, total_lvl, current_lvl):
	var diff_val = max_val - min_val
	var ratio_lvl = total_lvl / current_lvl
	var add_value = diff_val / ratio_lvl
	return min_val + add_value

func get_propriety_by_level(weapon_stats, weapon_property_level, propriety_name, weapon_value):
	for stat_dictionnary in weapon_stats.stats:
		if (propriety_name in stat_dictionnary) and (weapon_property_level != 0):
			#weapon_value = exponential_ratio(stat.min_value, stat.max_value, stat.number_of_levels)
			var stat = stat_dictionnary[propriety_name]
			if (stat.min_value is bool) or (stat.max_value is bool):
				return stat.max_value
			return linear_ratio(stat.min_value, stat.max_value, stat.number_of_levels, weapon_property_level)
	return weapon_value

func set_weapon_properties(weapon_editor: WeaponEditor, weapon_index: int):
	var current_index : int = 0
	
	for weapon_properties_levels in GlobalVariables.player_weapon_list:
		if current_index == weapon_index:
			weapon_editor.weapon_name = weapon_properties_levels.name
			weapon_editor.projectile_scene = GlobalVariables.all_weapon_list[current_index].projectile_packed_scene
			weapon_editor.weapon.side_sprite.texture = GlobalVariables.all_weapon_list[current_index].gui_texture
			
			weapon_editor.shooting_cooldown = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.shooting_cooldown_level, "shooting_cooldown", weapon_editor.shooting_cooldown)
			weapon_editor.balls_by_burt = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.balls_by_burt_level, "balls_by_burt", weapon_editor.balls_by_burt)
			weapon_editor.frequence_of_burt = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.frequence_of_burt_level, "frequence_of_burt", weapon_editor.frequence_of_burt)
			weapon_editor.precision = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.precision_level, "precision", weapon_editor.precision)
			weapon_editor.recoil_force = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.recoil_force_level, "recoil_force", weapon_editor.recoil_force)
			weapon_editor.ammo_size = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.ammo_size_level, "ammo_size", weapon_editor.ammo_size)
			weapon_editor.ammo_reloading_time = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.ammo_reloading_time_level, "ammo_reloading_time", weapon_editor.ammo_reloading_time)
			weapon_editor.projectile_speed = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.projectile_speed_level, "projectile_speed", weapon_editor.projectile_speed)
			weapon_editor.projectile_damages = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.projectile_damages_level, "projectile_damages", weapon_editor.projectile_damages)
			weapon_editor.projectile_impact_force = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.projectile_impact_force_level, "projectile_impact_force", weapon_editor.projectile_impact_force)
			weapon_editor.projectile_should_bounce = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.projectile_bouncing_level, "projectile_bouncing", weapon_editor.projectile_should_bounce)
			#weapon_editor.special_power_cooldown = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.special_power_cooldown_level, "special_power_cooldown", weapon_editor.special_power_cooldown)
			#weapon_editor.auto_lock_target = get_propriety_by_level(GlobalVariables.all_weapon_list[current_index], weapon_properties_levels.auto_lock_target_level, "auto_lock_target", weapon_editor.auto_lock_target)
			break
		current_index += 1
	weapon_editor.set_variables(weapon_editor.weapon)

func save():
	var save_file := FileAccess.open_encrypted("user://game.save", FileAccess.WRITE, GlobalVariables.encryption_key)
	
	var json_save := {
		"level": GlobalVariables.level,

		"glock_level": GlobalVariables.glock_level,
		"shotgun_level": GlobalVariables.shotgun_level,
		"mini_uzi_level": GlobalVariables.mini_uzi_level,
		"riffle_level": GlobalVariables.riffle_level,
		"machine_gun_level": GlobalVariables.machine_gun_level,
		"grenade_launcher_level": GlobalVariables.grenade_launcher_level,
		"sniper_level": GlobalVariables.sniper_level,
		"knife_level": GlobalVariables.knife_level,

		"grappling_hook_level": GlobalVariables.grappling_hook_level,

		"bulletproof_vest_level": GlobalVariables.bulletproof_vest_level,

		"index_weapon_selected": GlobalVariables.index_weapon_selected,
		"index_knife_selected": GlobalVariables.index_knife_selected,
	}
	
	save_file.store_string(JSON.stringify(json_save))
	save_file.close()
	

func load_save():
	var save_file := FileAccess.open_encrypted("user://game.save", FileAccess.READ, GlobalVariables.encryption_key)
	
	if save_file == null:
		return
	print("Loading game save")
	
	var save_file_content := save_file.get_as_text()
	var save_file_object = JSON.parse_string(save_file_content)

	GlobalVariables.level = save_file_object["level"]

	GlobalVariables.glock_level = save_file_object["glock_level"]
	GlobalVariables.shotgun_level = save_file_object["shotgun_level"]
	GlobalVariables.mini_uzi_level = save_file_object["mini_uzi_level"]
	GlobalVariables.riffle_level = save_file_object["riffle_level"]
	GlobalVariables.machine_gun_level = save_file_object["machine_gun_level"]
	GlobalVariables.grenade_launcher_level = save_file_object["grenade_launcher_level"]
	GlobalVariables.sniper_level = save_file_object["sniper_level"]
	GlobalVariables.knife_level = save_file_object["knife_level"]

	GlobalVariables.grappling_hook_level = save_file_object["grappling_hook_level"]

	GlobalVariables.bulletproof_vest_level = save_file_object["bulletproof_vest_level"]

	GlobalVariables.index_weapon_selected = save_file_object["index_weapon_selected"]
	GlobalVariables.index_knife_selected = save_file_object["index_knife_selected"]

	save_file.close()

