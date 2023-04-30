extends Projectile
class_name ThrowedWeapon

var time_stunning : float = 3

#func _ready():
#	print("THROWED WEAPON\n")

func handle_collision(collision: KinematicCollision2D):
	if !collision:
		return
	var object = collision.get_collider()
	
	if object.get_name() == "Walls":
		stop()
	
	if object.has_method("stunned"):
		object.stunned(time_stunning)
		stop()

func stop():
	speed = 0
	direction = Vector2.ZERO
