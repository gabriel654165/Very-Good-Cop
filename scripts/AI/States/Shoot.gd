extends AIState
class_name Shoot

var _player: Node2D = null;

func update(_delta: float) -> void:
	if _player != null:
		var current_position: Vector2 = state_machine._enemy.global_position
		var new_velocity: Vector2 = (_player.global_position - current_position).normalized()
		state_machine._enemy.global_rotation = new_velocity.angle()

		if state_machine.get_parent().global_transform.origin.distance_to(_player.global_transform.origin) > state_machine._enemy.distance_to_shoot + 40:
			state_machine.transition_to(state_machine.FOLLOW_PLAYER, { target = _player })
	
	if state_machine._weapon != null && _player != null:
		state_machine._weapon.shoot()


func enter(_msg := {}) -> void:
	_player = _msg["target"]
	state_machine.navigation_agent.set_process(false)
	state_machine.navigation_agent.set_physics_process(false)

func exit() -> void:
	state_machine.navigation_agent.set_process(true)
	state_machine.navigation_agent.set_physics_process(true)

func physics_update(delta: float) -> void:
	pass
