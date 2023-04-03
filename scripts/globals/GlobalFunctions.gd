extends Node

func get_speed(delta: float, speed: float) -> float:
	return speed * (delta * 60)

#to player
func add_weapon(weapon_name: String):
	pass

func add_passive_effect(passive_effect_name: String):
	pass
