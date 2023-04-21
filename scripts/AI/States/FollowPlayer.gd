extends AIState
class_name FollowPlayer

var _target: Node2D = null;

func update(_delta: float) -> void:
	if _target != null:
		set_movement_target(_target.global_transform.origin)
		if state_machine._enemy.global_transform.origin.distance_to(_target.global_transform.origin) <= state_machine._enemy.distance_to_shoot + 40:
			state_machine.transition_to(state_machine.SHOOT, { target = _target })

func enter(_msg := {}) -> void:
	_target = _msg["target"]
	vision_sensor.set_process(true)

func exit() -> void:
	vision_sensor.set_process(false)
