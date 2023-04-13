extends Node

func get_speed(delta: float, speed: float) -> float:
	return speed * (delta * 60)

#pythagorean algorithm
func get_distance(point1: Vector2, point2: Vector2) -> float:
	return sqrt(pow((point2.x - point1.x), 2) + pow((point2.y - point1.y), 2))

func is_inside_vector_2(aim_pos: Vector2, src_pos: Vector2, offset: Vector2):
	#print("src_pos + offset", src_pos + offset, " >= ", aim_pos)
	#print("src_pos - offset", src_pos - offset, " <=  ", aim_pos, "\n")
	
	var upper_y : float = aim_pos.y + offset.y
	var down_y : float = aim_pos.y - offset.y
	var upper_x : float = aim_pos.x + offset.x
	var down_x : float = aim_pos.x - offset.x
	
	var is_under_offset_y : bool = src_pos.y < upper_y
	var is_upper_offset_y : bool = src_pos.y > down_y
	var is_under_offset_x : bool = src_pos.x < upper_x
	var is_upper_offset_x : bool = src_pos.x > down_x
	
	#print("is_under_offset_y = ", is_under_offset_y)
	#print("is_upper_offset_y = ", is_upper_offset_y)
	#print("is_under_offset_x = ", is_under_offset_x)
	#print("is_upper_offset_x = ", is_upper_offset_x, "\n")
	
	if is_under_offset_y and is_upper_offset_y and is_under_offset_x and is_upper_offset_x:
		return true
	return false
