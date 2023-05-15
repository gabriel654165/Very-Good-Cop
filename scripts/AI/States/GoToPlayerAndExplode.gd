extends AIState
class_name GoToPlayerAndExplode

var _speed: float
var _target: Node2D
@onready var _explosionArea: Area2D = $"../../ExplosionDamageArea"

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
	
func exit() -> void:
	pass

func on_navigation_finished():
	state_machine.navigation_agent.set_process(false)
	state_machine.navigation_agent.set_physics_process(false)
	if _explosionArea.has_overlapping_bodies():
		for body in _explosionArea.get_overlapping_bodies():
			if body == state_machine._enemy:
				continue
			if body.has_method("handle_hit"):
				body.handle_hit(state_machine._enemy, 35)
	state_machine._enemy.handle_hit(state_machine._enemy, 999)
