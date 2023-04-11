extends Interaction
class_name CollisionInteraction

@export var collision_group : String = "character"
@onready var area2D = $Area2D as Area2D

var body_touching : Node = null

func get_body_touching() -> Character:
	var bodies = area2D.get_overlapping_bodies()
	var body_first_priority : Character = null
	
	for body in bodies:
		if body is Character:
			body_first_priority = body
		if body is Player:
			body_first_priority = body
	
	if body_first_priority != null:
		print("interaction : collision = TRUE by : ", body_first_priority.name)
		body_touching = body_first_priority
		is_triggered = true
	
	return body_first_priority

func _on_body_entered(body):
#	if !body.is_in_group(collision_group):
#		return
#	
#	print("interaction : collision = TRUE by : ", body.name)
#	body_touching = body
#	is_triggered = true
	pass

func _on_body_exited(body):
	print("interaction : collision = FALSE")
	if body_touching == body:
		body_touching = null
		is_triggered = false
	pass
