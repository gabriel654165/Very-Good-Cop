extends Node2D

class_name Room

@onready var room_config = find_child("RoomConfig")

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(room_config != null, "Add a room config to your room")
	spawn_enemies()
	#spawn_powerups()

# 
# Spawn powerups
#

func spawn_powerups():
	var packed_enemy:PackedScene = preload("res://scenes/characters/enemies/pistolero.tscn")

	var powerups_points_node:Node = room_config.find_child("PowerUpPoints")
	var powerups_spawn_points:Array = powerups_points_node.get_children().map(func(node:Node2D): return node.global_position)

	var nb_powerup_to_spawn:int = randi_range(0, powerups_spawn_points.size())

	powerups_spawn_points.shuffle()

#	for patrol_points in patrol_paths_vectors.slice(0, nb_enemy_to_spawn):
#		var enemy:Enemy = packed_enemy.instantiate()
#		enemy.patrol_points = patrol_points
#		add_child(enemy)
#		enemy.global_position = patrol_points[0]

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


func get_patrols_paths() -> Array:
	var patrols_node:Node = room_config.find_child("Patrols")
	var nb_of_patrols:int = patrols_node.get_child_count() if patrols_node != null else 0

	if nb_of_patrols == 0:
		return []
	return patrols_node.get_children().map(get_vectors_from_patrol_path)


func spawn_enemies():
	var packed_enemy:PackedScene = preload("res://scenes/characters/enemies/pistolero.tscn")

	var patrol_paths_vectors:Array = get_patrols_paths()

	var nb_enemy_to_spawn:int = randi_range(1, patrol_paths_vectors.size())

	patrol_paths_vectors.shuffle()

	for patrol_points in patrol_paths_vectors.slice(0, nb_enemy_to_spawn):
		var enemy:Enemy = packed_enemy.instantiate()
		enemy.patrol_points = patrol_points
		add_child(enemy)
		enemy.global_position = patrol_points[0]

