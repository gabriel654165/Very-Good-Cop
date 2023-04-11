extends Node

class_name LevelGenerator

# Width and Height size
const LevelSideSize:int = 9
const BaseNbOfRoomss:int = 5
const NoRoom:int = -1
const RoomPlaceholder:int = -2 
const Entrance:int = -3
const Exit:int = -4

var StartPos = Vector2i(LevelSideSize/2, LevelSideSize/2)

const CardinalPoints:Array[Vector2i] = [
	Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN
]


var dungeon_layout: Array # Double array representing the dungeon generation canvas
var every_room: Array # 1D Array that represents every room in the dungeon
var entrance_pos: Vector2i
var exit_pos: Vector2i

func _input(ev):
	# debug lol
	if Input.is_key_pressed(KEY_UP):
		$Camera2D.position.y -= 10
	if Input.is_key_pressed(KEY_DOWN):
		$Camera2D.position.y += 10
	if Input.is_key_pressed(KEY_LEFT):
		$Camera2D.position.x -= 10
	if Input.is_key_pressed(KEY_RIGHT):
		$Camera2D.position.x += 10

func _physics_process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	# NOTE: To change
	var number_of_rooms:int = BaseNbOfRoomss + (GlobalVariables.level + randi_range(0, 3))
	print("Generating level with " + String.num_int64(number_of_rooms) + " rooms")
	
	var t := Time.get_unix_time_from_system()

	reset_dungeon_layout()
	generate_dungeon_layout(number_of_rooms)
	fill_door_identifiers()
	
	print(Time.get_unix_time_from_system() - t)

	spawn_dungeon_with_rooms()

func reset_dungeon_layout():
	entrance_pos = Vector2i.ZERO
	exit_pos = Vector2i.ZERO
	every_room = [StartPos]
	dungeon_layout.resize(LevelSideSize)
	for idx in dungeon_layout.size():
		var abscissa: Array[int] = []
		abscissa.resize(LevelSideSize)
		abscissa.fill(NoRoom)
		dungeon_layout[idx] = abscissa 

# Generate the level structure, finds entrance and exit and fills "every_room" array
func generate_dungeon_layout(req_nb_rooms):
	assert(LevelSideSize % 2 != 0, "Level sides size should be odd")
	var to_visit: Array[Vector2i] = [StartPos]
	var deadends : Array[Vector2i] = []

	dungeon_layout[StartPos.y][StartPos.x] = RoomPlaceholder
	while !to_visit.is_empty():
		var current_pos:Vector2i = to_visit.pop_front()
		var no_neighbors:bool = true

		# Check for every neighbors if we should add it to the list of rooms
		for way in CardinalPoints:
			var pos:Vector2i = current_pos + way
			if bound_check(pos):
				continue
			if every_room.size() < req_nb_rooms && should_add_room_at(pos) && !every_room.has(pos):
				no_neighbors = false
				to_visit.push_back(pos)
				every_room.append(pos)
				dungeon_layout[pos.y][pos.x] = RoomPlaceholder

		# Edge cases, either try back from start position or start over if already tried
		if to_visit.is_empty() && every_room.size() != req_nb_rooms:
			if current_pos == StartPos && no_neighbors:
				reset_dungeon_layout()
				deadends = []
				no_neighbors = false
				dungeon_layout[StartPos.y][StartPos.x] = RoomPlaceholder
			to_visit.append(StartPos)

		# Deadends
		if no_neighbors:
			deadends.append(current_pos)

	# If first room has only 1 neighbor, it is a deadend
	if (number_of_empty_neighbors_at(StartPos) == 1):
		deadends.append(StartPos)
	assert(every_room.size() == req_nb_rooms, "Problem with level size")
	assert(deadends.size() >= 2, "Wrong deadends number")

	entrance_pos = deadends.min()
	exit_pos = find_farthest_cell_from(entrance_pos)

func number_of_empty_neighbors_at(pos:Vector2i) -> int:
	var empty_neighbors:int = 0
	
	for way in CardinalPoints:
		var neighbor_cell:Vector2i = pos + way
		if bound_check(neighbor_cell):
			continue
		if dungeon_layout[neighbor_cell.y][neighbor_cell.x] != NoRoom:
			empty_neighbors += 1
	return empty_neighbors

# For each room, gives an identifier that represents which doors are open
func fill_door_identifiers():
	for room in every_room:
		var door_id: int = 0
		for way_idx in CardinalPoints.size():
			var neighbor: Vector2i = room + CardinalPoints[way_idx]
			if bound_check(neighbor) || dungeon_layout[neighbor.y][neighbor.x] == NoRoom:
				continue
			door_id |= (1 << way_idx)
		dungeon_layout[room.y][room.x] = door_id
		

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
	const RoomSidesSize:int = 16 * (16 - 1)
	print(GlobalVariables.rooms_repository)
	for room in every_room:
		var relative_pos = Vector2i(room.x - 4, room.y - 4)
		var doors_id:int = dungeon_layout[room.y][room.x]
		if GlobalVariables.rooms_repository[doors_id] != null:
			var chosen_room:RoomData = GlobalVariables.rooms_repository[doors_id].pick_random()
			var instantiated_room:Node2D = chosen_room.factory.instantiate()
			call_deferred("add_child", instantiated_room)
			instantiated_room.position = Vector2i(RoomSidesSize * relative_pos.x, RoomSidesSize * relative_pos.y)
			$Camera2D.position = instantiated_room.position

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

static func load_all_rooms_from(path :String):
	var dir = DirAccess.open(path)

	if !path.ends_with("/"):
		path += "/"
	
	var t = Time.get_unix_time_from_system()
	
	assert(dir != null, "Cannot open " + path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path + file_name
		if dir.current_is_dir():
			load_all_rooms_from(full_path)

		if file_name.ends_with(".remap"):
			file_name.trim_suffix(".remap")

		if file_name.ends_with(".tscn"):
			var room:PackedScene = load(path + file_name)
			load_room(room, full_path)
		file_name = dir.get_next()
	print("Loaded every room in " + str(Time.get_unix_time_from_system() - t))

static func load_room(room:PackedScene, file_name:String):
	var room_nodes:PackedStringArray = room._bundled["names"]
	var doors_bitflags:int = room_nodes_to_door_bitflags(room_nodes)

	assert(doors_bitflags != 0, file_name + " room doesn't seem to have any doors")

	var room_data = RoomData.new()

	# If the first metadata is an int then it is the number of use of a room
	if room._bundled["variants"].size() >= 2 && room._bundled["variants"][1] is int:
		room_data.number_of_use = room._bundled["variants"][1]
	else:
		room_data.number_of_use = 1
	room_data.factory = room
	assert(doors_bitflags > 0 && doors_bitflags < GlobalVariables.rooms_repository.size())
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

