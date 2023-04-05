extends Interaction
class_name CollisionInteraction

@export var collision_group : String = "character"

var body_touching : Node = null

func get_body_touching() -> Character:
	return body_touching

func _on_body_entered(body):
	if !body.is_in_group(collision_group):
		return
	
	print("interaction : collision = TRUE by : ", body.name)
	body_touching = body
	is_triggered = true

func _on_body_exited(body):
	#print("interaction : collision = FALSE")
	body_touching = null
	is_triggered = false
