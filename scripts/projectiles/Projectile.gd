extends CharacterBody2D
class_name Projectile

@export var speed : int = 4
@export var damages : int = 20
@export var size : float = 1
@export var impact_force : float = 2

var projectile_owner : Node2D = null
var sprite : Sprite2D
var direction := Vector2.ZERO

func _init():
	scale = scale * size

func _ready():
#	print("PROJECTILE\n")
	scale = scale * size

func _move_and_collide(delta: float):
	if direction != Vector2.ZERO:
		velocity = direction * GlobalFunctions.get_speed(speed, delta)
		global_position += velocity
		var collision = move_and_collide(velocity * delta + velocity.normalized())
		
		handle_collision(collision)

#virtual func
func handle_collision(collision: KinematicCollision2D):
	pass

func destroy_instance():
	queue_free()

func set_sprite(sprite: Sprite2D):
	if self.sprite == null:
		self.sprite = get_node("Sprite2D")
	self.sprite.texture = sprite.texture

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()

func set_projectile_owner(projectile_owner: Node2D):
	self.projectile_owner = projectile_owner
