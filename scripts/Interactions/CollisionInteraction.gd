extends Interaction
class_name CollisionInteraction

@export var collision_group : String = "character"

var body_touching : Character = null

func get_body_touching() -> Character:
	return body_touching

# il ne réentre pas prcq c pas le meme collider
func _on_body_entered(body):
	
	if !body.is_in_group(collision_group):
		return
	
	print("interaction : collision = TRUE by : ", body.name)
	body_touching = body as Character
	is_triggered = true

func _on_body_exited(body):
	#print("interaction : collision = FALSE")
	body_touching = null
	is_triggered = false
