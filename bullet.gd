extends Area2D
class_name Bullet

@export var speed : int = 3

@onready var life_cycle_timer = $LifeCycleTimer

var direction := Vector2.ZERO

func _ready():
	life_cycle_timer.start()

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()
	

#signal
func _on_life_cycle_timer_timeout():
	queue_free()
