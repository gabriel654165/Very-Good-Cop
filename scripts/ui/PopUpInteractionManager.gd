extends Node2D
class_name PopUpInteractionManager

@export var text_scale : Vector2 = Vector2(2, 2)
@export var interaction_offset : Vector2 = Vector2(5, -60)

var current_interaction_gui : Node = null
var world_target : Node

func _process(delta):
	if current_interaction_gui == null:
		return
	
	if world_target != null:
		current_interaction_gui.global_position = world_target.get_global_transform_with_canvas().origin + interaction_offset
	else:
		current_interaction_gui.global_position = get_viewport_rect().size / 2 + interaction_offset


func handle_interaction_computed(interaction_obj: Node, active: bool, interaction_gui_scene: PackedScene):
	if active:
		generate_pop_up(interaction_obj, interaction_gui_scene)
	else:
		unload_pop_up()


func generate_pop_up(interaction_obj: Node, interaction_gui_scene: PackedScene):
	if interaction_gui_scene == null:
		return
	if current_interaction_gui != null:
		current_interaction_gui.queue_free()
	current_interaction_gui = interaction_gui_scene.instantiate()
	add_child(current_interaction_gui)
	current_interaction_gui.scale = text_scale
	world_target = interaction_obj


func unload_pop_up():
	if current_interaction_gui == null:
		return
	current_interaction_gui.queue_free()
