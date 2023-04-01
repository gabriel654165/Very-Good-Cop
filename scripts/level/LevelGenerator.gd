extends Node

class_name LevelGenerator

# Width and Height size
const LevelSideSize:int = 9
const BaseNbOfRoomss:int = 5
const NoRoom:int = -1
const RoomPlaceholder:int = -2 
const Entrance:int = -3
const Exit:int = -4 
const CardinalPoints:Array[Vector2i] = [
	Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN
]

var dungeon_layout: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_dungeon_layout()
	
	# NOTE: To change
	var number_of_rooms:int = BaseNbOfRoomss + (GlobalVariables.level + randi_range(0, 3))
	print("Generating level with " + String.num_int64(number_of_rooms) + " rooms")
	var t := Time.get_unix_time_from_system()
	reset_dungeon_layout()
	generate_dungeon_layout(45)
	print(Time.get_unix_time_from_system() - t)

	for n in dungeon_layout:
		print(n)
	spawn_dungeon_with_rooms()

func reset_dungeon_layout():
	dungeon_layout.resize(LevelSideSize)
	for idx in dungeon_layout.size():
		var abscissa: Array[int] = []
		abscissa.resize(LevelSideSize)
		abscissa.fill(NoRoom)
		dungeon_layout[idx] = abscissa 

# Generate the level structure
func generate_dungeon_layout(req_nb_rooms):
	assert(LevelSideSize % 2 != 0, "Level sides size should be odd")
	var rooms_added:int = 1
	var start_pos = Vector2i(LevelSideSize/2, LevelSideSize/2)
	var to_visit: Array[Vector2i] = [start_pos]
	var deadends : Array[Vector2i] = []

	dungeon_layout[start_pos.y][start_pos.x] = RoomPlaceholder
	while !to_visit.is_empty():
		var current_pos:Vector2i = to_visit.pop_front()
		var no_neighbors:bool = true

		# Check for every neighbors if we should add it to the list of rooms
		for way in CardinalPoints:
			var pos:Vector2i = current_pos + way
			if bound_check(pos):
				continue
			if rooms_added < req_nb_rooms && should_add_room_at(pos):
				no_neighbors = false
				to_visit.push_back(pos)
				dungeon_layout[pos.y][pos.x] = RoomPlaceholder
				rooms_added += 1

		# Edge cases, either try back from start position or start over if already tried
		if to_visit.is_empty() && rooms_added != req_nb_rooms:
			if current_pos == start_pos && no_neighbors:
				reset_dungeon_layout()
				deadends = []
				no_neighbors = false
				rooms_added = 0
				dungeon_layout[start_pos.y][start_pos.x] = RoomPlaceholder
			to_visit.append(start_pos)

		# Deadends
		if no_neighbors:
			deadends.append(current_pos)

	# If first room has only 1 neighbor, it is a deadend
	if (number_of_empty_neighbors_at(start_pos) == 1):
		deadends.append(start_pos)
	assert(rooms_added == req_nb_rooms, "Problem with level size")
	assert(deadends.size() >= 2, "Wrong deadends number")

	var entrance:Vector2i = deadends.min()
	dungeon_layout[entrance.y][entrance.x] = Entrance

	var exit:Vector2i = find_farthest_cell_from(entrance)
	dungeon_layout[exit.y][exit.x] = Exit

func number_of_empty_neighbors_at(pos:Vector2i) -> int:
	var empty_neighbors:int = 0
	
	for way in CardinalPoints:
		var neighbor_cell:Vector2i = pos + way
		if bound_check(neighbor_cell):
			continue
		if dungeon_layout[neighbor_cell.y][neighbor_cell.x] != NoRoom:
			empty_neighbors += 1
	return empty_neighbors


func bound_check(pos:Vector2i) -> bool:
	return (pos.x < 0 || pos.y < 0  || pos.x > (LevelSideSize - 1) || pos.y > (LevelSideSize - 1))

func should_add_room_at(pos:Vector2i) -> bool:
	if dungeon_layout[pos.y][pos.x] != NoRoom:
		return false

	if randf() < 0.45:
		return false

	return number_of_empty_neighbors_at(pos) <= 1 

# Choose and spawn each room according to the dungeon shapes
func spawn_dungeon_with_rooms():
	pass

#
# Find farthest cell from another cell
#

class CellVisitDistance:
	var cell:Vector2i
	var from:Vector2i
	var distance:int
	func duplicate() -> CellVisitDistance:
		var new := CellVisitDistance.new()
		new.cell = self.cell
		new.from = self.from
		new.distance = self.distance
		return new
		
func find_farthest_cell_from(pos:Vector2i) -> Vector2i:
	var cellvd = CellVisitDistance.new()
	cellvd.cell = pos
	var farthest_cellvd = find_farthest_cell_with_celldistance(cellvd, true)
	print("Player will have to pass by " + String.num_int64(farthest_cellvd.distance) + " rooms")
	return farthest_cellvd.cell 


func find_farthest_cell_with_celldistance(cellvd:CellVisitDistance, first = false) -> CellVisitDistance:
	var cell = cellvd.cell

	if bound_check(cell) || dungeon_layout[cell.y][cell.x] == NoRoom:
		var old_cellvd = cellvd.duplicate()
		old_cellvd.cell = cellvd.from
		old_cellvd.distance -= 1
		return old_cellvd

	var neighbors: Array[CellVisitDistance] = []
	for way in CardinalPoints:
		var new_cellvd = cellvd.duplicate()
		new_cellvd.cell += way
		if !first && cellvd.from == new_cellvd.cell:
			continue
		new_cellvd.distance += 1
		new_cellvd.from = cell
		neighbors.append(find_farthest_cell_with_celldistance(new_cellvd))

	var result:CellVisitDistance = neighbors.pop_front()
	for neighbor in neighbors:
		if result.distance < neighbor.distance:
			result = neighbor
	return result


#
## Loading rooms in memory
#

class RoomData:
	var number_of_use : int = 1
	var factory: PackedScene = null


static func load_all_rooms_from(path: String):
	# Adds / at the end of the path
	if !path.ends_with("/"):
		path += "/"

	# Open directory with error handling
	var dir = DirAccess.open(path)
	if dir == null:
		print("Cannot load rooms: error on folder " + path)
		return

	assert(GlobalVariables.rooms_repository.size() >= 16, "The room repository is not big enough")

	# Iterate on the directory content and act accordingly
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"): # If is a scene
			load_room(path, file_name)
		elif dir.current_is_dir():
			load_all_rooms_from(path + file_name)
		else:
			print("Wrong file in room folders: " + file_name)
		file_name = dir.get_next()


static func load_room(path: String, file_name:String):
	var room = load(path + file_name)
	var room_nodes:PackedStringArray = room._bundled["names"]
	var doors_bitflags:int = room_nodes_to_door_bitflags(room_nodes)
	
	assert(doors_bitflags != 0, file_name + " room doesn't seem to have any doors")
	
	var room_data = RoomData.new()

	# If the first metadata is an int then it is the number of use of a room
	if room._bundled["variants"].size() >= 2 && room._bundled["variants"][1] is int:
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

