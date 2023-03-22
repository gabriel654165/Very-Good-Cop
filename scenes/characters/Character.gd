extends CharacterBody2D
class_name Character

var force : Vector2 = Vector2.ZERO

func _ready():
	GlobalSignals.connect("bullet_fired_force", Callable(self, "give_recul"))

func give_recul(character: Character, direction: Vector2, force: float):
	character.force = direction * force
