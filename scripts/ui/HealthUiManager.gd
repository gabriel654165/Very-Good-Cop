extends Node2D
class_name HealthUiManager

@export var health_ui : PackedScene
@export var offset_position : Vector2 = Vector2(-25, -40)

var health_obj_list : Array[Health] = []
var health_ui_list : Array[Control] = []

func _ready():
	if health_ui == null:
		return
	
	#aller chercher tout les Health
	append_health_object_from_all_child_nodes(get_tree().root)
	
	var index : int = 0
	for health_obj in health_obj_list:
		var health_ui_instance = health_ui.instantiate()
		add_child(health_ui_instance)
		health_ui_list.append(health_ui_instance)
		set_health_ui_position(health_obj.get_global_transform_with_canvas().origin, health_ui_list[index])
		set_health_values(health_obj, health_ui_list[index])
		index += 1

func append_health_object_from_all_child_nodes(parent: Node):
	for child in parent.get_children():
		if child is Health:
			health_obj_list.append(child)
		if child.get_child_count() > 0:
			append_health_object_from_all_child_nodes(child)

func _process(delta):
	var index : int = 0
	while index < health_obj_list.size():
		var health_obj = health_obj_list[index]
		if health_obj == null:
			remove_health_bar(index)
			index += 1
			continue
		set_health_ui_position(health_obj.get_global_transform_with_canvas().origin, health_ui_list[index])
		index += 1

func remove_health_bar(index: int):
	health_obj_list.remove_at(index)
	health_ui_list[index].queue_free()
	health_ui_list.remove_at(index)

func set_health_ui_position(aim_position: Vector2, health_ui: Control):
	health_ui.global_position = aim_position + offset_position
	#print("aim position to canvas : ", aim_position, " global_position :", health_ui.global_position)

func set_health_values(health: Health, health_ui: Control):
	health_ui.set_max_health(health._get_max_health())
	health_ui.set_health(health._get_health())

#signals
func handle_character_health_changed(health: Health, value: float):
	var index : int = 0
	for health_obj in health_obj_list:
		if health_obj == health:
			health_ui_list[index].update_health_value(value)
		index += 1

func handle_character_max_health_changed(health: Health, value: float):
	var index : int = 0
	for health_obj in health_obj_list:
		if health_obj == health:
			health_ui_list[index].update_max_health_value(value)
		index += 1
