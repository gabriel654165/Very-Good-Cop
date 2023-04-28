extends CharacterBody2D
class_name Projectile

@export var speed : int = 4
@export var damages : int = 20
@export var size : float = 1
@export var impact_force : float = 2
@export var piercing_force : int = 0
@export var should_bounce : bool = false
@export var should_pierce_walls : bool = false

var projectile_owner : Node2D = null
var sprite : Sprite2D
var direction := Vector2.ZERO
var current_piercing_force : int = 0

func _init():
	scale = scale * size

func _ready():
	# Maybe never called and not compiling
	scale = scale * size

func _move_and_collide(delta: float):
	if direction != Vector2.ZERO:
		velocity = direction * GlobalFunctions.get_speed(speed, delta)
		global_position += velocity
		var collision = move_and_collide(velocity * delta + velocity.normalized())
		
		handle_collision(collision)

func handle_collision(collision: KinematicCollision2D):
	if !collision:
		return
	var object = collision.get_collider()
	
	if object.get_name() == "Walls":
		if should_bounce:
			direction = velocity.normalized().bounce(collision.get_normal())
		if !should_bounce and !should_pierce_walls:
			queue_free()
	handle_specific_collision(object)

func destroy_instance():
	queue_free()

func set_sprite(sprite: Sprite2D):
	if self.sprite == null:
		self.sprite = get_node("Sprite2D")
	self.sprite.texture = sprite.texture
	self.sprite.apply_scale(sprite.transform.get_scale())

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()

func set_projectile_owner(projectile_owner: Node2D):
	self.projectile_owner = projectile_owner

#virtual func
func handle_specific_collision(object: Object):
	pass
