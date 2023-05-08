extends Node2D
class_name Health

@export var max_health : int = 100 : set = _set_max_health, get = _get_max_health
@export var health : int = 100 : set = _set_health, get = _get_health


func _set_health(new_health):
	health = new_health
	
func _get_health():
	return health

func _set_max_health(new_max_health):
	GlobalSignals.character_max_health_changed.emit(self, new_max_health)
	max_health = new_max_health
	
func _get_max_health():
	return max_health

func hit(damages):
	GlobalSignals.character_health_changed.emit(self, -damages)
	health -= damages


func heal(heal_points):
	GlobalSignals.character_health_changed.emit(self, heal_points)
	health = clamp(health + heal_points, 0, max_health)
	#if (health + heal_points) > max_health:
	#	health = max_health
	#health += heal_points

func is_dead() -> bool:
	if health <= 0:
		return true
	return false
