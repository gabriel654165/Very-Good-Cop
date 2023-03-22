extends Character
class_name Enemy

@onready var ai = $AI
@onready var weapon : Weapon = $Weapon
@onready var health: Health = $Health

func _ready():
	ai.init(self, weapon)

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
