extends Interaction

func trigger(actor: Node):
	if !(actor is Player):
		return
	actor.recover_weapon()
	#print("trigger add weapon")
	
	#free the object
	get_owner().queue_free()
