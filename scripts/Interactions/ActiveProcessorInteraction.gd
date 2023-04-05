extends Interaction
class_name ActivateProcessorInteraction

@export var interaction_processor : InteractionManager

func trigger(actor: Node):
	interaction_processor.set_active(true)
	set_active(false)
