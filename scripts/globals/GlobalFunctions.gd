extends Node

func _ready():
	print("Game starting...")
	init_global_variables()
	randomize()

	LevelGenerator.load_all_rooms_from("res://scripts/level/rooms") # TODO: Going to change to res://scenes/...

func init_global_variables():
	GlobalVariables.rooms_repository.resize(0b1111 + 1) # All 4 doors in a room is represented as 0b1111 (bitflag) + make up the fact that we want the number of numbers from 0 to 0b1111 so +1

func get_speed(delta: float, speed: float) -> float :
	return speed * (delta * 60)
