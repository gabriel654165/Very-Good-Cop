extends Character
class_name Enemy

@onready var fsm: StateMachine = $StateMachine
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var room_config: RoomConfig = $"../RoomConfig"

@export var distance_to_shoot: float = 70
@export var point_value: float = 100

func _ready():
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position
	fsm.init(self, weapon_manager.weapon)

func handle_hit(damages):
	health.hit(damages)
	if health.is_dead():
		GlobalSignals.enemy_died.emit(self, point_value)
		#display le sprite au sol
		#qu'il arête de bouger etc

		#queue_free()
