extends Enemy
class_name Kamikaz

const GOTO_PLAYER_AND_EXPLODE = "GoToPlayerAndExplode"
const GOTO_PLAYER_AND_GRAB = "GoToPlayerAndGrab"

@export var percent_health: float = 0.2

func handle_hit(damager: Node2D, damages):
	super.handle_hit(damager, damages)
	var percent: float = health.health as float / health.max_health as float
	if percent <=percent_health:
		if GlobalVariables.level < 30:
			fsm.transition_to(GOTO_PLAYER_AND_EXPLODE)
		else:
			fsm.transition_to(GOTO_PLAYER_AND_GRAB)
