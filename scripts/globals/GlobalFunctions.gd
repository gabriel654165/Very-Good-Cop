extends Node

func _ready():
	print("Game starting...")
	init_global_variables()
	randomize()
	
	# TODO: Going to change to res://scenes/...
	print_func_time(
		Callable(LevelGenerator, "load_all_rooms_from").bind("res://scripts/level/rooms/"), # Just fancy stuff to use bind on a static func, I could also make a lambda where I call the function with the argument
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


func print_func_time(fn:Callable, message:=fn.get_method()):
	var t = Time.get_unix_time_from_system()

	fn.call()
	
	prints(message, "in", Time.get_unix_time_from_system() - t, "seconds")
