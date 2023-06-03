extends Node
class_name Minimap

var map : Array
var full_map : Array
var player_ref : Player
var entrance_room_pos : Vector2i = Vector2i.ZERO
var exit_room_pos : Vector2i = Vector2i.ZERO
var enemies_list_ref : Array[Enemy]
var powerups_list_ref : Array[PassiveEffect]


func init(player: Node, level_generator_instance: LevelGenerator, top_node: Node):
	player_ref = player
	entrance_room_pos = level_generator_instance.entrance_pos
	exit_room_pos = level_generator_instance.exit_pos
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is Enemy, enemies_list_ref, top_node)
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is PassiveEffect, powerups_list_ref, top_node)


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



func get_player_pos() -> Vector2:
	return LevelGenerator.world_to_precise_local_positon(player_ref.global_position)

func get_current_room_pos() -> Vector2:
	return LevelGenerator.world_to_local_positon(player_ref.global_position)

func get_item_pos_in_map(item_list_ref: Array, map: Array, item_ref: Node = null) -> Array[Vector2]:
	var items_pos_list : Array[Vector2] = []
	for item in item_list_ref:
		if item == null:
			continue
		var item_room := LevelGenerator.world_to_local_positon(item.global_position)
		if !map[item_room.y][item_room.x]:
			continue
		if item_ref != null:
			var item_ref_room := LevelGenerator.world_to_local_positon(item_ref.global_position)
			if item_room.x != item_ref_room.x or item_room.y != item_ref_room.y:
				continue
		items_pos_list.append(LevelGenerator.world_to_precise_local_positon(item.global_position))
	return items_pos_list

func get_room_enemies_pos_list() -> Array[Vector2]:
	return get_item_pos_in_map(enemies_list_ref, map, player_ref)

func get_room_powerups_pos_list() -> Array[Vector2]:
	return get_item_pos_in_map(powerups_list_ref, map, player_ref)

func get_full_map_enemies_pos_list() -> Array[Vector2]:
	return get_item_pos_in_map(enemies_list_ref, full_map)

func get_full_map_powerups_pos_list() -> Array[Vector2]:
	return get_item_pos_in_map(powerups_list_ref, full_map)

func get_map_enemies_pos_list() -> Array[Vector2]:
	return get_item_pos_in_map(enemies_list_ref, map)

func get_map_powerups_pos_list() -> Array[Vector2]:
	return get_item_pos_in_map(powerups_list_ref, map)


func _process(delta):
	assert(player_ref != null)
	assert(!map.is_empty())

	var current_room := LevelGenerator.world_to_local_positon(player_ref.global_position)

	if !map[current_room.y][current_room.x]:
		map[current_room.y][current_room.x] = true
		GlobalSignals.map_updated.emit()
