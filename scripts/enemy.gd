extends Character
class_name Enemy

@onready var ai = $AI
@onready var weapon : Weapon = $Weapon
@onready var health: Health = $Health

func _ready():
	ai.init(self, weapon)

func handle_hit(damages):
	health.hit(damages)
	if health.is_dead():
		queue_free()
