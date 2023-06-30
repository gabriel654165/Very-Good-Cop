extends Interaction
class_name ChangeCanvasVisibility

@export var interaction_gui_scene : PackedScene
@export var visibility : bool

var should_display_canvas : bool = false

func set_active(state:bool):
	super.set_active(state)
	GlobalSignals.interaction_computed.emit(self.get_owner(), state, interaction_gui_scene)
	GlobalSignals.change_interaction_marker_state.emit(self.get_owner(), state, self.get_owner().interaction_gui_texture, self.get_owner().interaction_name)

func _process(delta):
	if !is_active:
		return
	
	var last_state_canvas : bool = should_display_canvas
	
	should_display_canvas = \
		data.has('CollisionInteraction') \
		and data['CollisionInteraction']['body_touching'] is Player
	
	is_triggered = true
	
	if last_state_canvas != should_display_canvas:
		GlobalSignals.interaction_computed.emit(self.get_owner(), should_display_canvas, interaction_gui_scene)
		GlobalSignals.change_interaction_marker_state.emit(self.get_owner(), !should_display_canvas, self.get_owner().interaction_gui_texture, self.get_owner().interaction_name)
