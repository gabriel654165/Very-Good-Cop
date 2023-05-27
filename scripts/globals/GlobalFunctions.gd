extends Node

func _ready():
	init_global_variables()
	randomize()
	
	print_func_time(
		Callable(LevelGenerator, "load_all_rooms_from").bind("res://scenes/rooms/"), # Just fancy stuff to use bind on a static func, I could also make a lambda where I call the function with the argument
		"Loaded every room"
	)

	print_func_time(
		Callable(MusicPlaylistsPlayer, "load_all_playlists_from").bind("res://assets/musics/"),
		"Loaded every music"
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


func disable_all_game_objects(state: bool):
	var index : int = 1
	var characters_in_scene : Array = []

	append_in_array_on_condition(func(elem: Node): return elem is Character, characters_in_scene, get_tree().root)
	
	for character in characters_in_scene:
		if character != null:
			character.action_disabled = state
		else:
			characters_in_scene.remove_at(index)
			continue
		index += 1


func print_func_time(fn:Callable, message:=fn.get_method()):
	var t = Time.get_unix_time_from_system()

	fn.call()
	
	prints(message, "in", Time.get_unix_time_from_system() - t, "seconds")


func linear_ratio(min_val, max_val, total_lvl, current_lvl, error_value_case):
	if current_lvl == 0:
		return min_val
	if total_lvl == 0 or current_lvl > total_lvl:
		return error_value_case
	var diff_val = max_val - min_val
	var ratio_lvl = total_lvl / current_lvl
	var add_value = diff_val / ratio_lvl
	return min_val + add_value

func boolean_ratio(min_val, max_val, total_lvl, current_lvl, error_value_case):
	if current_lvl > total_lvl:
		return max_val
	if current_lvl == 0:
		return min_val
	elif current_lvl == 1:
		return max_val
	return error_value_case
	
func get_propriety_by_level(weapon_stats, weapon_property_level, propriety_name, weapon_default_value):
	for stat_dictionnary in weapon_stats.stats:
		if (propriety_name in stat_dictionnary):
			var stat = stat_dictionnary[propriety_name]
			
			if (stat.min_value is bool) or (stat.max_value is bool):
				return boolean_ratio(stat.min_value, stat.max_value, stat.number_of_levels, weapon_property_level, weapon_default_value)
			return linear_ratio(stat.min_value, stat.max_value, stat.number_of_levels, weapon_property_level, weapon_default_value)
	return weapon_default_value

func set_distance_weapon_properties(weapon_editor: WeaponEditor, weapon_index: int):
	var current_index : int = 0
	
	for weapon_properties_levels in GlobalVariables.player_distance_weapon_list:
		if current_index == weapon_index:
			weapon_editor.weapon_name = weapon_properties_levels.name
			weapon_editor.projectile_scene = GlobalVariables.all_distance_weapon_list[current_index].projectile_packed_scene
			
			var special_power_scene = GlobalVariables.all_distance_weapon_list[current_index].special_power_packed_scene
			var special_power_instance = special_power_scene.instantiate()
			weapon_editor.weapon.add_child(special_power_instance)
			weapon_editor.special_power = special_power_instance
			
			weapon_editor.weapon.side_sprite.texture = GlobalVariables.all_distance_weapon_list[current_index].gui_texture
			
			weapon_editor.shooting_cooldown = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.shooting_cooldown_lvl, "shooting_cooldown", weapon_editor.shooting_cooldown)
			weapon_editor.balls_by_burt = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.balls_by_burt_lvl, "balls_by_burt", weapon_editor.balls_by_burt)
			weapon_editor.frequence_of_burt = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.frequence_of_burt_lvl, "frequence_of_burt", weapon_editor.frequence_of_burt)
			weapon_editor.precision = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.precision_lvl, "precision", weapon_editor.precision)
			weapon_editor.recoil_force = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.recoil_force_lvl, "recoil_force", weapon_editor.recoil_force)
			weapon_editor.ammo_size = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.ammo_size_lvl, "ammo_size", weapon_editor.ammo_size)
			weapon_editor.ammo_reloading_time = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.ammo_reloading_time_lvl, "ammo_reloading_time", weapon_editor.ammo_reloading_time)
			weapon_editor.projectile_speed = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_speed_lvl, "projectile_speed", weapon_editor.projectile_speed)
			weapon_editor.projectile_damages = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_damages_lvl, "projectile_damages", weapon_editor.projectile_damages)
			weapon_editor.projectile_impact_force = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_impact_force_lvl, "projectile_impact_force", weapon_editor.projectile_impact_force)
			weapon_editor.projectile_should_bounce = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_bouncing_lvl, "projectile_bouncing", weapon_editor.projectile_should_bounce)
			weapon_editor.points_to_use_special_power = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.points_to_use_special_power_lvl, "points_to_use_special_power", weapon_editor.points_to_use_special_power)
			weapon_editor.auto_lock_target = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.auto_lock_target_lvl, "auto_lock_target", weapon_editor.auto_lock_target)
			break
		current_index += 1
	weapon_editor.set_variables(weapon_editor.weapon)

#func set_melee_weapon_properties(weapon_editor: WeaponEditor, weapon_index: int):
#	var current_index : int = 0
#	
#	for weapon_properties_levels in GlobalVariables.player_melee_weapon_list:
#		if current_index == weapon_index:
#			weapon_editor.weapon_name = weapon_properties_levels.name
#			weapon_editor.projectile_scene = GlobalVariables.all_melee_weapon_list[current_index].projectile_packed_scene
#			weapon_editor.weapon.side_sprite.texture = GlobalVariables.all_melee_weapon_list[current_index].gui_texture
#			
#			weapon_editor.shooting_cooldown = get_propriety_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.shooting_cooldown_lvl, "shooting_cooldown", weapon_editor.shooting_cooldown)
#			break
#		current_index += 1
#	weapon_editor.set_variables(weapon_editor.weapon)

func save():
	var save_file := FileAccess.open_encrypted("user://game.save", FileAccess.WRITE, GlobalVariables.encryption_key)
	
	var json_save := {
		"level": GlobalVariables.level,
		
		"player_distance_weapon_list": GlobalVariables.player_distance_weapon_list,
		"player_melee_weapon_list": GlobalVariables.player_melee_weapon_list,
		"player_equipment_list": GlobalVariables.player_equipment_list,
		
		"grappling_hook_level": GlobalVariables.grappling_hook_level,
		
		"index_distance_weapon_selected": GlobalVariables.index_distance_weapon_selected,
		"index_melee_weapon_selected": GlobalVariables.index_melee_weapon_selected,
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

	GlobalVariables.player_distance_weapon_list = save_file_object["player_distance_weapon_list"]
	GlobalVariables.player_melee_weapon_list = save_file_object["player_melee_weapon_list"]
	GlobalVariables.player_equipment_list = save_file_object["player_equipment_list"]
	
	GlobalVariables.grappling_hook_level = save_file_object["grappling_hook_level"]
	
	GlobalVariables.index_distance_weapon_selected = save_file_object["index_distance_weapon_selected"]
	GlobalVariables.index_melee_weapon_selected = save_file_object["index_melee_weapon_selected"]

	save_file.close()

