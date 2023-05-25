extends Node

class_name Minimap

var map : Array
var player_ref : Player

func load_map(m:Array):
	map = m.map(
		func(line:Array): 
			var new_line:Array
			new_line.resize(line.size())
			new_line.fill(false)
			return new_line \
		)


func get_minimap() -> Array:
	return map.filter(func(line): return line.any(func(room): return room))


func _process(delta):
	assert(player_ref != null)
	assert(!map.is_empty())

	var current_room := LevelGenerator.world_to_local_positon(player_ref.global_position)

	map[current_room.y][current_room.x] = true
