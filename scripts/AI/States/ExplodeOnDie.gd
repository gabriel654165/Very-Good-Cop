extends AIState
class_name ExplodeOnDie

var _target: Node2D = null;

func update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	state_machine.navigation_agent.set_process(false)
	state_machine.navigation_agent.set_physics_process(false)

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
