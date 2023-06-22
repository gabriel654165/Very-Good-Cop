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


func is_inside_range(aim_val: float, src_val: float, offset: float) -> bool:
	var max : float = aim_val + offset
	var min : float = aim_val - offset
	
	var is_inf_than_max : bool = src_val < max
	var is_sup_than_min : bool = src_val > min
	
	if is_inf_than_max and is_sup_than_min:
		return true
	return false

func is_inside_vector_2(aim_pos: Vector2, src_pos: Vector2, offset: Vector2) -> bool:
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


func disable_all_process(node: Node, disable: bool):
	node.set_process(!disable)
	node.set_physics_process(!disable)
	node.set_process_internal(!disable)
	node.set_process_unhandled_input(!disable)
	node.set_process_unhandled_key_input(!disable)


func disable_all_game_objects(state: bool):
	var index : int = 1
	var objects_in_scene : Array = []

	append_in_array_on_condition(func(elem: Node): return (elem is Character or elem is Projectile), objects_in_scene, get_tree().root)
	
	for obj in objects_in_scene:
		if obj != null:
			if obj is Player and "action_disabled" in obj:
				obj.action_disabled = state
				continue
			for child in obj.get_children():
				disable_all_process(child, state)
			disable_all_process(obj, state)
		else:
			objects_in_scene.remove_at(index)
			continue
		index += 1


func print_func_time(fn:Callable, message:=fn.get_method()):
	var t = Time.get_unix_time_from_system()

	fn.call()
	
	prints(message, "in", Time.get_unix_time_from_system() - t, "seconds")


func get_melee_weapon_animation_by_index(weapon_index: int) -> String:
	return get_weapon_animation_by_index(GlobalVariables.all_melee_weapon_list, weapon_index)

func get_melee_weapon_animation_by_name(weapon_name: String) -> String:
	return get_weapon_animation_by_name(GlobalVariables.all_melee_weapon_list, weapon_name)

func get_distance_weapon_animation_by_index(weapon_index: int) -> String:
	return get_weapon_animation_by_index(GlobalVariables.all_distance_weapon_list, weapon_index)

func get_distance_weapon_animation_by_name(weapon_name: String) -> String:
	return get_weapon_animation_by_name(GlobalVariables.all_distance_weapon_list, weapon_name)

func get_weapon_animation_by_index(weapon_list: Array, weapon_index: int) -> String:
	var animation_name : String = ""
	var dic_index : int = 0
	
	for weapon_dictionnary in weapon_list:
		if dic_index == weapon_index:
			animation_name = weapon_dictionnary.animation
			break
		dic_index += 1
	return animation_name

func get_weapon_animation_by_name(weapon_list: Array, weapon_name: String) -> String:
	var animation_name : String = ""
	
	for weapon_dictionnary in weapon_list:
		if weapon_name == weapon_dictionnary.name:
			animation_name = weapon_dictionnary.animation
			break
	return animation_name


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
	
func get_property_by_level(weapon_stats, weapon_property_level, propriety_name, weapon_default_value):
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
			
			weapon_editor.weapon.shooting_sound = AudioStreamMP3.new()
			(weapon_editor.weapon.shooting_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes(GlobalVariables.all_distance_weapon_list[current_index].shooting_sound)
			weapon_editor.weapon.reloading_sound = AudioStreamMP3.new()
			(weapon_editor.weapon.reloading_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes(GlobalVariables.all_distance_weapon_list[current_index].reloading_sound)
			
			var special_power_scene = GlobalVariables.all_distance_weapon_list[current_index].special_power_packed_scene
			var special_power_instance = special_power_scene.instantiate()
			weapon_editor.weapon.add_child(special_power_instance)
			weapon_editor.special_power = special_power_instance
			
			weapon_editor.weapon.side_sprite.texture = GlobalVariables.all_distance_weapon_list[current_index].gui_texture
			weapon_editor.shot_shell_texture = GlobalVariables.all_distance_weapon_list[current_index].shot_shells_texture
			
			weapon_editor.shooting_cooldown = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.shooting_cooldown_lvl, "shooting_cooldown", weapon_editor.shooting_cooldown)
			weapon_editor.balls_by_burt = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.balls_by_burt_lvl, "balls_by_burt", weapon_editor.balls_by_burt)
			weapon_editor.frequence_of_burt = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.frequence_of_burt_lvl, "frequence_of_burt", weapon_editor.frequence_of_burt)
			weapon_editor.precision = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.precision_lvl, "precision", weapon_editor.precision)
			weapon_editor.recoil_force = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.recoil_force_lvl, "recoil_force", weapon_editor.recoil_force)
			weapon_editor.ammo_size = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.ammo_size_lvl, "ammo_size", weapon_editor.ammo_size)
			weapon_editor.ammo_reloading_time = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.ammo_reloading_time_lvl, "ammo_reloading_time", weapon_editor.ammo_reloading_time)
			weapon_editor.projectile_speed = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_speed_lvl, "projectile_speed", weapon_editor.projectile_speed)
			weapon_editor.projectile_damages = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_damages_lvl, "projectile_damages", weapon_editor.projectile_damages)
			weapon_editor.projectile_piercing_force = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_piercing_force_lvl, "projectile_piercing_force", weapon_editor.projectile_piercing_force)
			weapon_editor.projectile_impact_force = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_impact_force_lvl, "projectile_impact_force", weapon_editor.projectile_impact_force)
			weapon_editor.projectile_should_bounce = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.projectile_bouncing_lvl, "projectile_bouncing", weapon_editor.projectile_should_bounce)
			weapon_editor.points_to_use_special_power = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.points_to_use_special_power_lvl, "points_to_use_special_power", weapon_editor.points_to_use_special_power)
			weapon_editor.auto_lock_target = get_property_by_level(GlobalVariables.all_distance_weapon_list[current_index], weapon_properties_levels.auto_lock_target_lvl, "auto_lock_target", weapon_editor.auto_lock_target)
			break
		current_index += 1
	weapon_editor.set_variables(weapon_editor.weapon)

func set_melee_weapon_properties(melee_weapon: Knife, weapon_index: int):
	var current_index : int = 0
	
	for weapon_properties_levels in GlobalVariables.player_melee_weapon_list:
		if current_index == weapon_index:
			melee_weapon.weapon_name = weapon_properties_levels.name
			melee_weapon.side_sprite.texture = GlobalVariables.all_melee_weapon_list[current_index].gui_texture
			melee_weapon.woosh_sound = AudioStreamMP3.new()
			(melee_weapon.woosh_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes(GlobalVariables.all_melee_weapon_list[current_index].woosh_sound)
			melee_weapon.attack_cooldown = get_property_by_level(GlobalVariables.all_melee_weapon_list[current_index], weapon_properties_levels.attack_cooldown_lvl, "attack_cooldown", melee_weapon.attack_cooldown)
			melee_weapon.attack_distance = get_property_by_level(GlobalVariables.all_melee_weapon_list[current_index], weapon_properties_levels.attack_distance_lvl, "attack_distance", melee_weapon.attack_distance)
			melee_weapon.damages = get_property_by_level(GlobalVariables.all_melee_weapon_list[current_index], weapon_properties_levels.damages_lvl, "damages", melee_weapon.damages)
			melee_weapon.can_throw = get_property_by_level(GlobalVariables.all_melee_weapon_list[current_index], weapon_properties_levels.can_throw_lvl, "can_throw", melee_weapon.can_throw)
			melee_weapon.points_to_use_special_power = get_property_by_level(GlobalVariables.all_melee_weapon_list[current_index], weapon_properties_levels.points_to_use_special_power_lvl, "points_to_use_special_power", melee_weapon.points_to_use_special_power)
			break
		current_index += 1
	melee_weapon.update_properties()


func set_equipment_properties(character: Character):
	var bonus_health : float = 0
	var bonus_speed : float = 0
	var current_index : int = 0
	
	for equipment_properties_levels in GlobalVariables.player_equipment_list:
		bonus_health += get_property_by_level(GlobalVariables.all_equipment_list[current_index], equipment_properties_levels.health_bonus_lvl, "health_bonus", character.health.health_base_value)
		bonus_speed += get_property_by_level(GlobalVariables.all_equipment_list[current_index], equipment_properties_levels.speed_bonus_lvl, "speed_bonus", character.base_speed)
		current_index += 1
	
	# base value + bonus equipment
	character.health.max_health = character.health.health_base_value + bonus_health
	character.health.health = character.health.max_health
	character.speed = character.base_speed + bonus_speed


func set_throwable_object_properties(throwable_object_manager: ThrowableObjectManager, object_index: int):
	var current_index : int = 0
	
	for object_properties_levels in GlobalVariables.player_throwable_object_list:
		if current_index == object_index:
			throwable_object_manager.object_name = object_properties_levels.name
			throwable_object_manager.projectile_scene = GlobalVariables.all_throwable_object_list[current_index].projectile_packed_scene
			throwable_object_manager.side_sprite.texture = GlobalVariables.all_throwable_object_list[current_index].gui_texture
			throwable_object_manager.throwing_sound = AudioStreamMP3.new()
			(throwable_object_manager.throwing_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes(GlobalVariables.all_throwable_object_list[current_index].throw_sound)
			throwable_object_manager.throwing_cooldown.wait_time = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.throwing_cooldown_lvl, "throwing_cooldown", throwable_object_manager.throwing_cooldown.wait_time)
			throwable_object_manager.ammo_size = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.ammo_size_lvl, "ammo_size", throwable_object_manager.ammo_size)
			throwable_object_manager._current_nb_projectiles = throwable_object_manager.ammo_size
			throwable_object_manager.precision = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.precision_lvl, "precision", throwable_object_manager.precision)
			throwable_object_manager.projectile_speed = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.projectile_speed_lvl, "projectile_speed", throwable_object_manager.projectile_speed)
			throwable_object_manager.projectile_damages = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.projectile_damages_lvl, "projectile_damages", throwable_object_manager.projectile_damages)
			throwable_object_manager.projectile_impact_force = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.projectile_impact_force_lvl, "projectile_impact_force", throwable_object_manager.projectile_impact_force)
			throwable_object_manager.projectile_should_bounce = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.projectile_bouncing_lvl, "projectile_bouncing", throwable_object_manager.projectile_should_bounce)
			throwable_object_manager.projectile_max_distance = get_property_by_level(GlobalVariables.all_throwable_object_list[current_index], object_properties_levels.projectile_max_distance_lvl, "projectile_max_distance", throwable_object_manager.projectile_max_distance)
			break
		current_index += 1


func reset_player_levels():
	GlobalVariables.level = 1
	GlobalVariables.money = 0
	GlobalVariables.index_distance_weapon_selected = 0
	GlobalVariables.index_melee_weapon_selected = 0
	GlobalVariables.index_throwable_object_selected = 0
	GlobalFunctions.reset_distance_weapon_levels()
	GlobalFunctions.reset_melee_weapon_levels()
	GlobalFunctions.reset_throwable_object_levels()
	GlobalFunctions.reset_equipment_levels()


func reset_distance_weapon_levels():
	for weapon in GlobalVariables.player_distance_weapon_list:
		weapon.unlocked = true if weapon.name == "glock" else false
		weapon.special_power_unlocked = false
		weapon.shooting_cooldown_lvl= 0 if weapon.shooting_cooldown_lvl != -1 else -1
		weapon.balls_by_burt_lvl= 0 if weapon.balls_by_burt_lvl != -1 else -1
		weapon.frequence_of_burt_lvl= 0 if weapon.frequence_of_burt_lvl != -1 else -1
		weapon.precision_lvl= 0 if weapon.precision_lvl != -1 else -1
		weapon.recoil_force_lvl= 0 if weapon.recoil_force_lvl != -1 else -1
		weapon.ammo_size_lvl= 0 if weapon.ammo_size_lvl != -1 else -1
		weapon.ammo_reloading_time_lvl= 0 if weapon.ammo_reloading_time_lvl != -1 else -1
		weapon.projectile_speed_lvl= 0 if weapon.projectile_speed_lvl != -1 else -1
		weapon.projectile_damages_lvl= 0 if weapon.projectile_damages_lvl != -1 else -1
		weapon.projectile_piercing_force_lvl= 0 if weapon.projectile_piercing_force_lvl != -1 else -1
		weapon.projectile_impact_force_lvl= 0 if weapon.projectile_impact_force_lvl != -1 else -1
		weapon.projectile_bouncing_lvl= 0 if weapon.projectile_bouncing_lvl != -1 else -1
		weapon.points_to_use_special_power_lvl= 0 if weapon.points_to_use_special_power_lvl != -1 else -1
		weapon.auto_lock_target_lvl= 0 if weapon.auto_lock_target_lvl != -1 else -1


func reset_melee_weapon_levels():
	for weapon in GlobalVariables.player_melee_weapon_list:
		weapon.unlocked = true if weapon.name == "police_baton" else false
		weapon.special_power_unlocked = false
		weapon.attack_cooldown_lvl= 0 if weapon.attack_cooldown_lvl != -1 else -1
		weapon.attack_distance_lvl= 0 if weapon.attack_distance_lvl != -1 else -1
		weapon.damages_lvl= 0 if weapon.damages_lvl != -1 else -1
		weapon.can_throw_lvl= 0 if weapon.can_throw_lvl != -1 else -1
		weapon.points_to_use_special_power_lvl=  0 if weapon.points_to_use_special_power_lvl != -1 else -1


func reset_equipment_levels():
	for equipment in GlobalVariables.player_equipment_list:
		equipment.unlocked = false
		equipment.health_bonus_lvl= 0 if equipment.health_bonus_lvl != -1 else -1
		equipment.speed_bonus_lvl= 0 if equipment.speed_bonus_lvl != -1 else -1


func reset_throwable_object_levels():
	for object in GlobalVariables.player_throwable_object_list:
		object.unlocked = true if object.name == "grenade" else false
		object.ammo_size_lvl= 0 if object.ammo_size_lvl != -1 else -1


func save():
	var save_file := FileAccess.open_encrypted("user://game.save", FileAccess.WRITE, GlobalVariables.encryption_key)
	
	var json_save := {
		"level": GlobalVariables.level,
		"money": GlobalVariables.money,
		
		"player_distance_weapon_list": GlobalVariables.player_distance_weapon_list,
		"player_melee_weapon_list": GlobalVariables.player_melee_weapon_list,
		"player_equipment_list": GlobalVariables.player_equipment_list,
		"player_throwable_object_list": GlobalVariables.player_throwable_object_list,
		
		"grappling_hook_level": GlobalVariables.grappling_hook_level,
		
		"index_distance_weapon_selected": GlobalVariables.index_distance_weapon_selected,
		"index_melee_weapon_selected": GlobalVariables.index_melee_weapon_selected,
		"index_throwable_object_selected": GlobalVariables.index_throwable_object_selected,
		
		"current_playlist": GlobalVariables.current_playlist,
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
	GlobalVariables.money = save_file_object["money"]

	GlobalVariables.player_distance_weapon_list = save_file_object["player_distance_weapon_list"]
	GlobalVariables.player_melee_weapon_list = save_file_object["player_melee_weapon_list"]
	GlobalVariables.player_equipment_list = save_file_object["player_equipment_list"]
	GlobalVariables.player_throwable_object_list = save_file_object["player_throwable_object_list"]
	
	GlobalVariables.grappling_hook_level = save_file_object["grappling_hook_level"]
	
	GlobalVariables.index_distance_weapon_selected = save_file_object["index_distance_weapon_selected"]
	GlobalVariables.index_melee_weapon_selected = save_file_object["index_melee_weapon_selected"]
	GlobalVariables.index_throwable_object_selected = save_file_object["index_throwable_object_selected"]
	
	GlobalVariables.current_playlist = save_file_object["current_playlist"]

	save_file.close()

