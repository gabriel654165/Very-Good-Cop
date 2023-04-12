extends Character
class_name EnemyController

@onready var weapon : Weapon = $Weapon
@onready var health: Health = $Health
@onready var fsm = $StateMachine

func _ready():
	fsm.init(self, weapon)

func handle_hit(damages):
	health.hit(damages)
	if health.is_dead():
		queue_free()
