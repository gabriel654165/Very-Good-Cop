extends State
class_name AIState

var vision_sensor: VisionSensor = null
var hearing_sensor: HearingSensor = null
var enemy: Enemy = null
var state_machine: AIStateMachine = null :
	get:
		return state_machine
	set(value):
		state_machine = value
		enemy = state_machine._enemy
		vision_sensor = state_machine._enemy.vision_sensor
		hearing_sensor = state_machine._enemy.hearing_sensor

func set_target(movement_target: Node2D):
	state_machine.navigation_agent.target_position = movement_target.global_transform.origin

func set_movement_target(movement_target: Vector2):
	state_machine.navigation_agent.target_position = movement_target

func physics_update(_delta: float) -> void:
	var is_at_distance : bool = GlobalFunctions.is_inside_range(enemy.distance_to_shoot, state_machine.navigation_agent.distance_to_target(), 2.0)
	
	if (state_machine.state is Patrol) and state_machine.navigation_agent.is_navigation_finished():
		state_machine.navigation_agent.set_velocity(Vector2.ZERO)
	elif (state_machine.state is Patrol) and !state_machine.navigation_agent.is_navigation_finished():
		move()
	
	if ((state_machine.state is FollowPlayer) or (state_machine.state is Shoot)) and is_at_distance:
		state_machine.navigation_agent.set_velocity(Vector2.ZERO)
	elif ((state_machine.state is FollowPlayer) or (state_machine.state is Shoot)) and !is_at_distance:
		move()

func move() -> void:
	var current_agent_position: Vector2 = state_machine._enemy.global_transform.origin
	var next_path_position: Vector2 = state_machine.navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * state_machine._movement_speed

	state_machine.navigation_agent.set_velocity(new_velocity)
	state_machine._enemy.global_rotation = new_velocity.angle()
