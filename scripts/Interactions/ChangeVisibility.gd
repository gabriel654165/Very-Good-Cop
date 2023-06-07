extends Interaction
class_name ChangeCanvasVisibility

#@export var canvas : CanvasItem
@export var interaction_gui_scene : PackedScene
@export var visibility : bool

var should_display_canvas : bool = false

func set_active(state:bool):
	super.set_active(state)
	if !state:
		GlobalSignals.interaction_computed.emit(self.get_parent(), state, interaction_gui_scene)
	

func _process(delta):
	if !is_active:
		return
	
	var last_state_canvas : bool = should_display_canvas
	
	should_display_canvas = \
		data.has('CollisionInteraction') \
		and data['CollisionInteraction']['body_touching'] is Player
	
	is_triggered = true
	
	if last_state_canvas != should_display_canvas:
		GlobalSignals.interaction_computed.emit(self.get_parent(), should_display_canvas, interaction_gui_scene)
