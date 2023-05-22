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


func print_func_time(fn:Callable, message:=fn.get_method()):
	var t = Time.get_unix_time_from_system()

	fn.call()
	
	prints(message, "in", Time.get_unix_time_from_system() - t, "seconds")


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

