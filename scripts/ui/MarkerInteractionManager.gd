extends Node2D
class_name MarkerInteractionManager

@export var active : bool = false
@export var marker_gui_scene : PackedScene
@export var marker_scale : Vector2 = Vector2(1, 1)
@export var marker_offset : Vector2 = Vector2(0, 0)

var marker_gui_dict : Dictionary


func set_active(state: bool):
	if marker_gui_scene == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()


func _process(delta):
	for marker_gui_key in marker_gui_dict:
		var world_target = marker_gui_key
		var marker_gui = marker_gui_dict.get(marker_gui_key)
		
		if world_target != null:
			marker_gui.global_position = world_target.get_global_transform_with_canvas().origin + marker_offset
		else:
			marker_gui.global_position = get_viewport_rect().size / 2 + marker_offset


func change_interaction_marker_state(interaction_obj: Node, active: bool, interaction_gui_texture: Texture, interaction_name: String):
	if active:
		generate_marker(interaction_obj, interaction_name, interaction_gui_texture)
	else:
		unload_marker(interaction_obj)

func generate_ui():
	var markable_obj_list : Array = []
	var index : int = 0

	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return (elem is PassiveEffectEditor or (elem is EndLevelInteractionEditor and elem.visible)) , markable_obj_list, get_tree().root)
	for markable_obj in markable_obj_list:
		if ("interaction_name" in markable_obj) and ("interaction_gui_texture" in markable_obj):
			generate_marker(markable_obj, markable_obj.interaction_name, markable_obj.interaction_gui_texture)
		else:
			generate_marker(markable_obj)


func unload_ui():
	for marker_gui_key in marker_gui_dict:
			marker_gui_dict.erase(marker_gui_key)


func generate_marker(interaction_obj: Node, text_str: String = "test", img_texture: Texture = null):
	if marker_gui_scene == null or active == false:
		return
	
	var new_marker : Control = marker_gui_scene.instantiate()
	
	add_child(new_marker)
	new_marker.scale = marker_scale
	if img_texture != null:
		new_marker.get_node("PanelContainer/MarkerContainer/ImageTextureRect").texture = img_texture
	new_marker.get_node("PanelContainer/MarkerContainer/TextLabel").text = text_str
	
	var new_marker_gui_dict : Dictionary = {
		interaction_obj: new_marker,
	}
	
	marker_gui_dict.merge(new_marker_gui_dict)


func unload_marker(interaction_obj: Node):
	for marker_gui_key in marker_gui_dict:
		if marker_gui_key == interaction_obj:
			var marker_gui = marker_gui_dict.get(marker_gui_key)
			
			marker_gui_dict.erase(marker_gui_key)
			marker_gui.queue_free()
