extends Node

class_name LevelGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	var empty_dungeon = dungeon_shape()
	populate_dungeon(empty_dungeon)
	
# Generate the level structure
func dungeon_shape():
	pass

func populate_dungeon(dungeon):
	pass


#
## Loading rooms in memory
#

class RoomData:
	var number_of_use : int = 1
	var factory: PackedScene = null

static func load_all_rooms_from(path: String):
	if !path.ends_with("/"):
		path += "/"

	var dir = DirAccess.open(path)
	if dir == null:
		print("Cannot load rooms: error on folder " + path)
		return

	assert(GlobalVariables.rooms_repository.size() >= 16, "The room repository is not big enough")

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			load_all_rooms_from(path + file_name)
		elif file_name.ends_with(".tscn"):
			load_room(path, file_name)
		else:
			print("Wrong file in room folders: " + file_name)
		file_name = dir.get_next()

static func load_room(path: String, file_name:String):
	var room = load(path + file_name)
	var room_nodes:PackedStringArray = room._bundled["names"]
	var doors_bitflags:int = room_nodes_to_door_bitflags(room_nodes)
	
	assert(doors_bitflags != 0, file_name + " room doesn't seem to have any doors")
	
	var room_data = RoomData.new()
	# Assign number of uses from variant PackedScene data
	# Must first first metadata as int
	if room._bundled["variants"].size() > 2 && room._bundled["variants"][1] is int:
		room_data.number_of_use = room._bundled["variants"][1]
	room_data.factory = room

	if GlobalVariables.rooms_repository[doors_bitflags] == null:
		var new_room_array : Array[RoomData] = [room_data]
		GlobalVariables.rooms_repository[doors_bitflags] = new_room_array 
	else:
		GlobalVariables.rooms_repository[doors_bitflags].append(room_data)
	print("Loaded room: " + file_name)

static func room_nodes_to_door_bitflags(room_nodes:PackedStringArray) -> int:
	var door_names:Array[String]= ["_DLeft", "_DRight", "_DUp", "_DDown"]
	var result:int = 0
	
	for idx in door_names.size():
		var has_door = room_nodes.has(door_names[idx])
		result |= (int(has_door) << idx)
	
	return result

