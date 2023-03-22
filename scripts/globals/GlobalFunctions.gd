extends Node

func get_speed(delta: float, speed: float) -> float :
	return speed * (delta * 60)
