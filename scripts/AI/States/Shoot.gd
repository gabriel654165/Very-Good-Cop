extends AIState
class_name Shoot

var _target: Node2D = null;

func update(_delta: float) -> void:
	if _target != null:
		var current_position: Vector2 = state_machine._enemy.global_position
		var new_velocity: Vector2 = (_target.global_position - current_position).normalized()
		state_machine._enemy.global_rotation = new_velocity.angle()
		set_movement_target(_target.global_position)

		if state_machine.get_parent().global_transform.origin.distance_to(_target.global_transform.origin) > state_machine._enemy.distance_to_shoot:
			state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = _target })

	if state_machine._weapon != null && _target != null:
		state_machine._weapon.shoot()

func enter(_msg := {}) -> void:
	_target = _msg["target"]
