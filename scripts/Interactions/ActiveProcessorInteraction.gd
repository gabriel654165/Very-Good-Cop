extends Interaction
class_name ActivateProcessorInteraction

var interaction_processor : InteractionManager

func set_active(new_state: bool):
	is_active = new_state
	if is_active:
		interaction_processor.set_active(true)
		set_active(false)
