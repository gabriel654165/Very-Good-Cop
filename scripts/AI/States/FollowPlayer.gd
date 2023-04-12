extends AIState
class_name FollowPlayer

var _player: Node2D = null;

func update(_delta: float) -> void:
	if _player != null:
		set_movement_target(_player.global_transform.origin)
		if state_machine._enemy.global_transform.origin.distance_to(_player.global_transform.origin) <= state_machine._enemy.distance_to_shoot + 40:
			state_machine.transition_to(state_machine.SHOOT, { target = _player })

func enter(_msg := {}) -> void:
	_player = _msg["target"]
