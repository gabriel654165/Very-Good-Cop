extends Node
class_name Minimap

var map : Array
var full_map : Array
var player_ref : Player


func load_map(m:Array):
	map = m.map(
		func(line:Array): 
			var new_line:Array
			new_line.resize(line.size())
			new_line.fill(false)
			return new_line \
		)
	full_map = m.map(
		func(line:Array):
			return line.map(func(elem): return elem != LevelGenerator.NoRoom)\
		)


func get_first_room_index_x() -> int:
	var min_x_index : int = 100
	var current_x_index : int = 0
	
	for row in full_map:
		for is_room in row:
			if !is_room:
				current_x_index += 1
				continue
			if current_x_index < min_x_index:
				min_x_index = current_x_index
			current_x_index += 1
		current_x_index = 0
	return min_x_index

func get_first_room_index_y() -> int:
	var min_y_index : int = 0
	var current_y_index : int = 0
	var has_value := false
	
	for row in full_map:
		for is_room in row:
			if !is_room:
				continue
			has_value = true
			min_y_index = current_y_index
			break
		if has_value:
			break
		current_y_index += 1
	return min_y_index


func get_width() -> int:
	var full_map_no_empty_line = full_map.filter(func(line): return line.any(func(room): return room))
	return (full_map_no_empty_line.map(func(row): return row.rfind(true)).max() - \
		full_map_no_empty_line.map(func(row): return row.find(true)).min() \
	) + 1


func get_heigth() -> int:
	var full_map_no_empty_line = full_map.filter(func(line): return line.any(func(room): return room))
	return full_map_no_empty_line.size()



func get_minimap() -> Array:
	return map
	#return map.filter(func(line): return line.any(func(room): return room))


func get_full_minimap() -> Array:
	return full_map

func get_player_pos() -> Vector2:
	return LevelGenerator.world_to_precise_local_positon(player_ref.global_position)
	#return player_ref.global_position

func _process(delta):
	assert(player_ref != null)
	assert(!map.is_empty())

	var current_room := LevelGenerator.world_to_local_positon(player_ref.global_position)

	if !map[current_room.y][current_room.x]:
		map[current_room.y][current_room.x] = true
		GlobalSignals.map_updated.emit()
