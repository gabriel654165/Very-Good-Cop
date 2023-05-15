extends Enemy
class_name Kamikaz

const GOTO_PLAYER_AND_EXPLODE = "GoToPlayerAndExplode"

func handle_hit(damager: Node2D, damages):
	super.handle_hit(damager, damages)
	var percent: float = health.health as float / health.max_health as float
	if percent <= 0.2:
		fsm.transition_to(GOTO_PLAYER_AND_EXPLODE)
