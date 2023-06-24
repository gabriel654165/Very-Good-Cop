extends AIState
class_name Patrol

var current_point: Vector2
var wait_timer = Timer.new()

var current_point_index: int = 0

func _ready():
	await owner.ready

	wait_timer.timeout.connect(_on_wait_point_timeout)
	wait_timer.wait_time = state_machine._enemy.patrol_wait
	wait_timer.one_shot = true
	add_child(wait_timer)

func get_target():
	if state_machine._enemy.patrol_points.size() == 0:
		return

	if state_machine._enemy.patrol_type == Enemy.PatrolType.Sequence:
		current_point_index = (current_point_index + 1) % state_machine._enemy.patrol_points.size()
		current_point = state_machine._enemy.patrol_points[current_point_index]
	else:
		var random_pos = state_machine._enemy.patrol_points.pick_random()
		while state_machine._enemy.patrol_points.size() > 1 and current_point == random_pos:
			random_pos = state_machine._enemy.patrol_points.pick_random()
		current_point = random_pos
	set_movement_target(current_point)

func enter(_msg := {}) -> void:
	if !state_machine.navigation_agent.target_reached.is_connected(_on_target_reached):
		state_machine.navigation_agent.target_reached.connect(_on_target_reached)
	if !hearing_sensor.sound_heard.is_connected(_on_sound_heard):
		hearing_sensor.sound_heard.connect(_on_sound_heard)
	get_target()

func exit() -> void:
	hearing_sensor.sound_heard.disconnect(_on_sound_heard)
	state_machine.navigation_agent.target_reached.disconnect(_on_target_reached)

func update(_delta: float) -> void:
	if vision_sensor.current_target != null:
		state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = vision_sensor.current_target.get_parent() })

#signals 
func _on_wait_point_timeout():
	get_target()

func _on_target_reached() -> void:
	if wait_timer.is_stopped():
		wait_timer.start()

func _on_sound_heard(source: Node2D, location: Vector2, intensity: float) -> void:
	state_machine.transition_to(state_machine.GOTO_LOOK_AROUND, {
		target_pos = location,
		goto_time = state_machine._enemy.pursue_find_time,
		wait_before_look_around = state_machine._enemy.pursue_wait_before_look_around
	})	
