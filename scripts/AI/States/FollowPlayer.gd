extends AIState
class_name FollowPlayer

var _target: Node2D = null;

var direction: Vector2

func update(_delta: float) -> void:
	if _target != null:
		set_movement_target(_target.global_transform.origin)
		if state_machine._enemy.global_transform.origin.distance_to(_target.global_transform.origin) <= state_machine._enemy.distance_to_shoot + 40:
			state_machine.transition_to(state_machine.SHOOT, { target = _target })

func enter(_msg := {}) -> void:
	_target = _msg["target"]
	if !vision_sensor.lost_target.is_connected(_on_loose_target):
		vision_sensor.lost_target.connect(_on_loose_target)

func exit() -> void:
	vision_sensor.lost_target.disconnect(_on_loose_target)

#signals 
func _on_loose_target(target: DetectableTarget):
	var move_direction = Vector2()
	if target.get_parent() is Player:
		move_direction = (target.get_parent() as Player).move_direction

	state_machine.transition_to(state_machine.PURSUE, {
		last_target_pos = target.global_position,
		target_move_direction = move_direction
	})
	_target = null
