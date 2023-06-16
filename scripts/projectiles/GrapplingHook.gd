extends Projectile
class_name GrapplingHook

@onready var line_cable = $Line2D as Line2D

@export var drag_speed : int = 500 

@export var max_distance := 350

func _move_and_collide(delta: float):
	if direction != Vector2.ZERO:
		velocity = direction * GlobalFunctions.get_speed(speed * 75, delta)
		var collision = move_and_collide(velocity * delta)
		handle_collision(collision)


func _specific_process(delta):
	if projectile_owner != null:
		line_cable.set_point_position(0, to_local(global_position))
		line_cable.set_point_position(1, to_local(projectile_owner.global_position))
	#crash when player is dead an the graplinng hook do his job
	if (global_position - projectile_owner.global_position).length() > max_distance:
		stop()
		queue_free()
		if projectile_owner is Player: #or Character
			projectile_owner.hook_deployed = false

func handle_collision(collision: KinematicCollision2D):
	if !collision:
		return
	var object = collision.get_collider()

	if object.get_name() == "Walls" or object is Character:
		stop()
		GlobalSignals.emit_signal("grappling_cable_drag", projectile_owner, self, global_position, drag_speed)

