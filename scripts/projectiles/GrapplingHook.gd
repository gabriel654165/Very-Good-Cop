extends Projectile
class_name GrapplingHook

@onready var line_cable = $Line2D as Line2D

@export var drag_speed : int = 500 

func _physics_process(delta):
	_move_and_collide(delta)
	if projectile_owner != null:
		line_cable.set_point_position(0, to_local(global_position))
		line_cable.set_point_position(1, to_local(projectile_owner.global_position))

func handle_collision(collision: KinematicCollision2D):
	if !collision:
		return
	var object = collision.get_collider()
	
	if object.get_name() == "Walls" or object is Character:
		stop()
		GlobalSignals.emit_signal("grappling_cable_drag", projectile_owner, self, global_position, drag_speed)

#dans projectile aussi
func stop():
	speed = 0
	direction = Vector2.ZERO
