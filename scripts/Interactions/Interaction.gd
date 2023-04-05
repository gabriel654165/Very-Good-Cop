extends Node
class_name Interaction

@export var for_who : TRIGGER_ACTOR = TRIGGER_ACTOR.NONE
@export var is_active : bool = false
var is_triggered : bool = false

enum TRIGGER_ACTOR {
	NONE,
	PLAYER,
	ENEMY,
	EVERYBODY
}

func trigger(body: Node):
	pass

func set_active(new_state: bool):
	is_active = new_state
	is_triggered = false

func check_trigger() -> bool:
	if !is_active:
		return false
	return is_triggered
