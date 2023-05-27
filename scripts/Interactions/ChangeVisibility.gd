extends Interaction
class_name ChangeCanvasVisibility
@export var canvas : CanvasItem
@export var visibility : bool

func set_active(b:bool):
	super.set_active(b)
	if !b:
		canvas.visible = !visibility
	

func _process(delta):
	if !is_active:
		return
	
	var should_change_visibility := \
		data.has('CollisionInteraction') \
		and data['CollisionInteraction']['body_touching'] is Player

	is_triggered = true
	canvas.visible = visibility if should_change_visibility else !visibility
