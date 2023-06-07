extends Interaction
class_name CollisionInteraction

@export var collision_group : String = "character"
@onready var area2D = $Area2D as Area2D

var body_touching : Node = null

func update_data(common_data:Dictionary):
	if !common_data.has('CollisionInteraction'):
		common_data['CollisionInteraction'] = Dictionary()
	common_data['CollisionInteraction']['body_touching'] = body_touching

func get_body_touching() -> Character:
	var bodies = area2D.get_overlapping_bodies()
	var body_first_priority : Character = null
	
	for body in bodies:
		if body is Character:
			body_first_priority = body
		if body is Player:
			body_first_priority = body
	
	if body_first_priority != null:
		body_touching = body_first_priority
		is_triggered = true

	return body_first_priority

func _on_body_exited(body):
	if body_touching == body:
		body_touching = null
		is_triggered = false
	
