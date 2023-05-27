extends Node2D

class_name Room

@onready var room_config = find_child("RoomConfig")
var should_spawn_stuff := true

#1 -> [1 - 1]
#2 -> [2 - 3]
#3 -> [2 - 3]
#4 -> [3 - 5]
#5 -> [3 - 5]
#6 -> [4 - 6]
#7 -> [4 - 6]
#8 -> [5 - 8]
func nb_of_enemies(array:Array):
	var theorical_maximum := array.size()
	var minimum :int= 1 + GlobalVariables.level/2
	var maximum :int= minimum * 2 - minimum/2

	return min(randi_range(minimum, maximum), theorical_maximum)


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(room_config != null, "Add a room config to your room")
	if should_spawn_stuff:
		spawn_with_room_config(
			"Patrols", 
			get_patrol_paths, 
			spawn_enemy,
			true,
			true,
			nb_of_enemies
		)
		spawn_with_room_config("PowerUpPoints", get_children_positions_array, spawn_powerups)


func spawn_with_room_config(
	node_name:String, 
	process_node:Callable, # Takes the node as a parameter and returns an array. The elements of the array will be passed as a parameter to spawn_function
	spawn_function:Callable,
	random_nb_to_spawn := true, # Will call spawn_function between 1 time and process_node's array size time if true, else will call the func for each element of the array  
	shuffle := true, # shuffle process_node's array before spawning
	random_nb_func := func(array:Array): return randi_range(1, array.size())
	):
	var node:Node = room_config.find_child(node_name)
	var processed_node_as_array:Array = process_node.call(node)

	var nb_to_spawn:int = random_nb_func.call(processed_node_as_array) if random_nb_to_spawn else processed_node_as_array.size()

	if shuffle:
		processed_node_as_array.shuffle()

	for element in processed_node_as_array.slice(0, nb_to_spawn):
		spawn_function.call(element)


func get_children_positions_array(node:Node):
	return node.get_children().map(func(n:Node2D): return n.global_position)


#
# Spawn powerups
#


func spawn_powerups(position:Vector2):
	var power_ups:Array[PackedScene] = [
		preload("res://scenes/powerups/SlowMotion.tscn"),
		preload("res://scenes/powerups/Speed.tscn"),
		preload("res://scenes/powerups/Damage.tscn"),
		preload("res://scenes/powerups/Heal.tscn"),
	]
	var power_up = power_ups.pick_random().instantiate()
	add_child(power_up)
	power_up.global_position = position


#
# Spawn enemies
#

func get_vectors_from_patrol_path(patrol_path_node:Node) -> Array:
	if patrol_path_node.get_child_count() == 0:
		assert(patrol_path_node is Node2D, "Patrol path node has no points or single position (" + patrol_path_node.name + ")" )
		return [(patrol_path_node as Node2D).global_position]
	
	var patrol_nodes:Array = patrol_path_node.get_children()

	return patrol_nodes.map(
		func(elem):
			assert(elem is Node2D, "Patrol point with no position")
			return (elem as Node2D).global_position
	)


func get_patrol_paths(node:Node) -> Array:
	var nb_of_children:int = node.get_child_count() if node != null else 0

	if nb_of_children == 0:
		return []
	return node.get_children().map(get_vectors_from_patrol_path)


func spawn_enemy(patrol_points:Array):
	var packed_enemy:PackedScene = preload("res://scenes/characters/enemies/pistolero.tscn")

	var enemy:Enemy = packed_enemy.instantiate()
	enemy.patrol_points = patrol_points
	add_child(enemy)
	enemy.global_position = patrol_points[0]
