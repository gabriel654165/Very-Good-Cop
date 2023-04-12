extends AIState

var _player: Node2D = null;

@export var distance: float = 70

func update(_delta: float) -> void:
	if _player != null and state_machine.get_parent().global_transform.origin.distance_to(_player.global_transform.origin) > distance + 40:
		state_machine.transition_to(state_machine.FOLLOW_PLAYER, { target = _player })
	
	if state_machine._weapon != null && _player != null:
		state_machine._enemy.rotation = state_machine._enemy.global_position.direction_to(_player.global_position).angle()
		state_machine._weapon.shoot()
	else:
		print("Enemy spoted but enemy has no weapon")

func enter(_msg := {}) -> void:
	_player = _msg["target"]
	state_machine.navigation_agent.set_process(false)
	state_machine.navigation_agent.set_physics_process(false)
	
	print("Shoot")

func exit() -> void:
	state_machine.navigation_agent.set_process(true)
	state_machine.navigation_agent.set_physics_process(true)
