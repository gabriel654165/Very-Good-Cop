extends State
class_name AIState

var vision_sensor: VisionSensor = null
var state_machine: AIStateMachine = null :
	get:
		return state_machine
	set(value):
		state_machine = value
		vision_sensor = state_machine._enemy.vision_sensor

func set_target(movement_target: Node2D):
	state_machine.navigation_agent.target_position = movement_target.global_transform.origin

func set_movement_target(movement_target: Vector2):
	state_machine.navigation_agent.target_position = movement_target	

func physics_update(delta: float) -> void:
	move()

func move() -> void:
	if state_machine.navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = state_machine._enemy.global_transform.origin
	var next_path_position: Vector2 = state_machine.navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * state_machine.movement_speed

	state_machine.navigation_agent.set_velocity(new_velocity)
	state_machine._enemy.global_rotation = new_velocity.angle()
