extends CharacterBody2D
class_name Character

var force : Vector2 = Vector2.ZERO

func _ready():
	GlobalSignals.connect("bullet_fired_force", Callable(self, "apply_force"))

func apply_force(character: Character, direction: Vector2, force: float):
	character.force = direction * force

