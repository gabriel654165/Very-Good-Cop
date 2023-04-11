extends CharacterBody2D
class_name Projectile

#@onready var sprite = $Sprite2D as Sprite2D
var sprite : Sprite2D

@export var speed : int = 4
@export var damages : int = 20
@export var size : float = 1
@export var impact_force : float = 2

var direction := Vector2.ZERO

func _init():
	scale = scale * size

func _ready():
#	print("PROJECTILE\n")
	scale = scale * size

func destroy_instance():
	queue_free()

func set_sprite(sprite: Sprite2D):
	if self.sprite == null:
		self.sprite = get_node("Sprite2D")
	self.sprite.texture = sprite.texture

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()
