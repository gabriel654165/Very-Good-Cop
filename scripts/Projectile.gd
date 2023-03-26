extends CharacterBody2D
class_name Projectile

@export var speed : int = 4
@export var damages : int = 20
@export var size : float = 1
@export var impact_force : float = 2

var direction := Vector2.ZERO

func _ready():
	scale = scale * size

func destroy_instance():
	queue_free()

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()
