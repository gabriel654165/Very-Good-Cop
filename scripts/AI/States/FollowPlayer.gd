extends AIState
class_name FollowPlayer

var _target: Node2D = null;

var direction: Vector2
var _last_target_pos: Vector2
var _last_target_move_direction = Vector2()

func update(_delta: float) -> void:
	if _target != null:
		set_movement_target(_target.global_transform.origin)
		if state_machine._enemy.global_transform.origin.distance_to(_target.global_transform.origin) <= state_machine._enemy.distance_to_shoot + 40:
			state_machine.transition_to(state_machine.SHOOT, { target = _target })
	else:
		if state_machine._enemy.global_transform.origin.distance_to(_last_target_pos) <= 20:
			state_machine.transition_to(state_machine.GOTO_LOOK_AROUND, {
			target_pos = state_machine._enemy.global_transform.origin + _last_target_move_direction * state_machine._enemy.pursue_move_distance,
			goto_time = state_machine._enemy.pursue_find_time,
			wait_before_look_around = state_machine._enemy.pursue_wait_before_look_around
		})

func enter(_msg := {}) -> void:
	_target = _msg["target"]
	if !vision_sensor.lost_target.is_connected(_on_loose_target):
		vision_sensor.lost_target.connect(_on_loose_target)

func exit() -> void:
	vision_sensor.lost_target.disconnect(_on_loose_target)

#signals 
func _on_loose_target(target: DetectableTarget):
	_last_target_move_direction = Vector2()
	if target.get_parent() is Player:
		_last_target_move_direction = (target.get_parent() as Player).move_direction

	_last_target_pos = target.global_position
	set_movement_target(_last_target_pos)
	_target = null
