extends Character
class_name Enemy

@onready var ai = $AI

func _ready():
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position
	ai.init(self, weapon_manager.weapon)

func _process(delta):
	if self.force != Vector2.ZERO:
		velocity += self.force
		self.force = Vector2.ZERO
	global_position += velocity
	move_and_slide()
	velocity = Vector2.ZERO

func handle_hit(damages):
	health.hit(damages)
	if health.is_dead():
		queue_free()
