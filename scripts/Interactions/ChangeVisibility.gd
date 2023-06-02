extends Interaction
class_name ChangeCanvasVisibility
@export var canvas : CanvasItem
@export var visibility : bool

func set_active(state:bool):
	super.set_active(state)
	if !state:
		canvas.visible = !visibility
	

func _process(delta):
	if !is_active:
		return
	
	var should_change_visibility := \
		data.has('CollisionInteraction') \
		and data['CollisionInteraction']['body_touching'] is Player

	is_triggered = true
	canvas.visible = visibility if should_change_visibility else !visibility
