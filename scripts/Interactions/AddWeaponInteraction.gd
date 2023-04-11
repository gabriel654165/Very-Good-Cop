extends Interaction

func trigger(actor: Node):
	if !(actor is Player):
		return
	actor.set_active_assigned_weapon()
	print("trigger")
	#free the object
	get_tree().root.queue_free()
