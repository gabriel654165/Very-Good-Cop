extends StateMachine
class_name AIStateMachine

@onready var navigation_agent: NavigationAgent2D = $"../NavigationAgent2D"

var _movement_speed: float = 50.0

var _weapon : Weapon = null
var _enemy : Enemy = null

const PATROL = "Patrol"
const FOLLOW_TARGET = "Follow Target"
const SHOOT = "Shoot To Target"

signal state_changed(new_state: AIState)

func init(enemy: Enemy, new_weapon: Weapon, speed: float):
	_enemy = enemy
	_weapon = new_weapon
	_movement_speed = speed
	
	navigation_agent.velocity_computed.connect(on_velocity_computed)
	
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	super._ready()
	
func on_velocity_computed(safe_velocity: Vector2) -> void:
	_enemy.velocity = safe_velocity
	_enemy.move_and_slide()

