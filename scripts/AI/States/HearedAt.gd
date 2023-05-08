extends AIState
class_name HearedAt

var _position: Vector2

func update(_delta: float) -> void:
	if state_machine._enemy.agent.is_navigation_finished():
		pass

func enter(_msg := {}) -> void:
	_position = _msg["position_to_move"]
	set_movement_target(_position)
	if !vision_sensor.can_see_target.is_connected(_on_can_see_target):
		vision_sensor.can_see_target.connect(_on_can_see_target)

func exit() -> void:
	vision_sensor.can_see_target.disconnect(_on_can_see_target)

#signals 
func _on_can_see_target(target: DetectableTarget):
	state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = target.get_parent() })
