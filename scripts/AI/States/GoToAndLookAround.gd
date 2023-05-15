extends AIState
class_name GoToAndLookAround

var target_pos: Vector2
var goto_time: float
var find_timer = Timer.new()
var wait_rotation_timer = Timer.new()

var tween: Tween

func _ready():
	await owner.ready

	find_timer.timeout.connect(_on_pursuit_time_timeout)
	find_timer.one_shot = true
	add_child(find_timer)
	
	wait_rotation_timer.timeout.connect(_on_wait_point_timeout)
	wait_rotation_timer.one_shot = true
	add_child(wait_rotation_timer)

func enter(_msg := {}) -> void:
	if !vision_sensor.can_see_target.is_connected(_on_see_target):
		vision_sensor.can_see_target.connect(_on_see_target)
	if !state_machine.navigation_agent.navigation_finished.is_connected(_on_navigation_finished):
		state_machine.navigation_agent.navigation_finished.connect(_on_navigation_finished)

	stop_tween()
	target_pos = _msg["target_pos"]
	assert(target_pos != null)
	set_movement_target(target_pos)

	# interrupt the state after X seconds
	var goto_time: float = _msg["goto_time"]
	if goto_time != null:
		find_timer.wait_time = goto_time
		find_timer.start()

	# wait look around time
	var rotation_time: float = _msg["wait_before_look_around"]
	assert(rotation_time != null)
	wait_rotation_timer.wait_time = rotation_time

func exit() -> void:
	vision_sensor.can_see_target.disconnect(_on_see_target)
	state_machine.navigation_agent.navigation_finished.disconnect(_on_navigation_finished)
	find_timer.stop()
	wait_rotation_timer.stop()
	stop_tween()

#signals
func _on_navigation_finished():
	wait_rotation_timer.start()

func _on_see_target(target: DetectableTarget):
	state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = target })

func _on_pursuit_time_timeout():
	wait_rotation_timer.start()

func _on_wait_point_timeout():
	tween = get_tree().create_tween()
	var initial_degree = state_machine._enemy.rotation_degrees
	tween.tween_property(state_machine._enemy, "rotation_degrees", initial_degree + state_machine._enemy.pursue_look_angle, 1)
	tween.tween_interval(state_machine._enemy.pursue_look_interval)
	tween.tween_property(state_machine._enemy, "rotation_degrees", initial_degree - (state_machine._enemy.pursue_look_angle * 2), 1)
	tween.tween_interval(state_machine._enemy.pursue_look_interval)
	tween.tween_property(state_machine._enemy, "rotation_degrees", initial_degree + state_machine._enemy.pursue_look_angle, 1)
	tween.tween_interval(state_machine._enemy.pursue_look_interval)	
	tween.tween_callback(func(): state_machine.transition_to(state_machine.PATROL))
	
func stop_tween():
	if tween != null:
		tween.stop()
	tween = null
