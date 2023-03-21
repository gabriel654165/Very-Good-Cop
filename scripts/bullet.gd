extends Area2D
class_name Bullet

@export var speed : int = 4
@export var damages : int = 20
@export var size : int = 1

@onready var life_cycle_timer = $LifeCycleTimer

var direction := Vector2.ZERO

func _ready():
	life_cycle_timer.start()
	scale = scale * size

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed * (delta * 60)
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()

#signals
func _on_life_cycle_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.get_name() == "Walls":
		queue_free()
		
	if body.has_method("handle_hit"):
		body.handle_hit(damages)
		queue_free()
