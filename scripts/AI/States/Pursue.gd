extends AIState
class_name Pursue

var _last_target_pos: Vector2

var target_move_direction: Vector2
var find_timer = Timer.new()
var wait_rotation_timer = Timer.new()

var tween: Tween

var searching: bool

func _ready():
	await owner.ready

	find_timer.timeout.connect(_on_pursuit_time_timeout)
	find_timer.wait_time = state_machine._enemy.pursue_find_time
	find_timer.one_shot = true
	add_child(find_timer)
	
	wait_rotation_timer.timeout.connect(_on_wait_point_timeout)
	wait_rotation_timer.wait_time = state_machine._enemy.pursue_wait_rotation_time
	wait_rotation_timer.one_shot = true
	add_child(wait_rotation_timer)

func update(_delta: float) -> void:
	if state_machine._enemy.global_transform.origin.distance_to(_last_target_pos) <= 20 and not searching:
		searching = true
		find_timer.start()
		set_movement_target(state_machine._enemy.global_transform.origin + target_move_direction * 500)

func enter(_msg := {}) -> void:
	_last_target_pos = _msg["last_target_pos"]
	target_move_direction = _msg["target_move_direction"]
	set_movement_target(_last_target_pos)
	
	if !vision_sensor.can_see_target.is_connected(_on_see_target):
		vision_sensor.can_see_target.connect(_on_see_target)

func exit() -> void:
	stop_tween()
	searching = false	
	vision_sensor.can_see_target.disconnect(_on_see_target)

#signals 
func _on_see_target(target: DetectableTarget):
	state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = target })

func _on_pursuit_time_timeout():
	wait_rotation_timer.start()

func _on_wait_point_timeout():
	stop_tween()
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
