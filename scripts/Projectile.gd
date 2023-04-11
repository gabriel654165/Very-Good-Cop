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
	scale = scale * size
	print("PROJECTILE\n")
#	print("name child = ", get_child(0).name)
#	print("name sprite = ", get_node("Sprite2D").name)
#	print("name child sprite = ", get_child(0).get_node("Sprite2D").name, "\n")
#	sprite = get_node("Sprite2D")

func destroy_instance():
	queue_free()

func set_sprite(sprite: Sprite2D):
	if self.sprite == null:
		self.sprite = get_node("Sprite2D")
		print("sprite == null\n")
		
	self.sprite.texture = sprite.texture
	print("self.sprite assigned to sprite sent\n")
	#self.sprite.sprite = load("res://assets/PNG/weapon_silencer.png")
	
	if self.sprite == null:
		print("sprite tjr == null\n")

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()
