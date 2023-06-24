extends AIState
class_name GoToPlayerAndExplode

var _speed: float
var _target: Node2D

var time_before_explode: float = 3

func enter(_msg := {}) -> void:
#	_speed = _msg["speed"]
	state_machine._movement_speed *= 3
	_target = get_tree().current_scene.find_child("Player")
	set_movement_target(_target.global_position)

	if not state_machine.navigation_agent.navigation_finished.is_connected(on_navigation_finished):
		state_machine.navigation_agent.navigation_finished.connect(on_navigation_finished)

func update(_delta: float) -> void:
	if state_machine._enemy.global_transform.origin.distance_to(_target.global_transform.origin) <= 35:
		on_navigation_finished()
	set_movement_target(_target.global_position)

func on_navigation_finished():
	state_machine.transition_to(state_machine.EXPLODE, {
		explode_time = time_before_explode
	})

