class_name AIStateMachine
extends StateMachine

@onready var sprite = $"../Sprite2D"
@onready var navigation_agent: NavigationAgent2D = $"../NavigationAgent2D"

var movement_speed: float = 50.0

var _weapon : Weapon = null
var _enemy : EnemyController = null

const PATROL = "Patrol"
const FOLLOW_PLAYER = "Follow Player"
const SHOOT = "Shoot"

signal state_changed(new_state)


func init(enemy: EnemyController, new_weapon: Weapon):
	_enemy = enemy
	_weapon = new_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	var room_config_node: Node = get_node_or_null("../../RoomConfig")
	var room_config: RoomConfig = null
	
	if room_config_node != null:
		room_config = room_config_node as RoomConfig
		
	print(room_config)
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.room_config = room_config
	super._ready()
