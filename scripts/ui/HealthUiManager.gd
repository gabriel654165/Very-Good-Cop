extends Node2D
class_name HealthUiManager

@export var active : bool = false
@export var health_ui : PackedScene
@export var offset_position : Vector2 = Vector2(-25, -40)

var health_obj_list : Array[Health] = []
var health_ui_list : Array[Control] = []


func _ready():
	if health_ui == null:
		active = false

func set_active(state: bool):
	if health_ui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()

func generate_ui():
	#aller chercher tout les Health
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is Health, health_obj_list, get_tree().root)
	
	var index : int = 0
	for health_obj in health_obj_list:
		var health_ui_instance := health_ui.instantiate()
		

		add_child(health_ui_instance)

		assert(health_ui_instance is CanvasItem)
		(health_ui_instance as CanvasItem).visible = false
		
		health_ui_list.append(health_ui_instance)
		set_health_ui_position(health_obj.get_global_transform_with_canvas().origin, health_ui_list[index])
		set_health_values(health_obj, health_ui_list[index])
		index += 1

func unload_ui():
	pass

func _process(delta):
	if !active:
		return
	var index : int = 0
	while index < health_obj_list.size():
		var health_obj := health_obj_list[index]
		var health_canvas := health_ui_list[index]

		if health_obj == null:
			remove_health_bar(index)
			index += 1
			continue
		elif health_canvas.visible == false and health_obj.health < health_obj.max_health:
			health_canvas.visible = true
		set_health_ui_position(health_obj.get_global_transform_with_canvas().origin, health_ui_list[index])
		index += 1

func remove_health_bar(index: int):
	health_obj_list.remove_at(index)
	health_ui_list[index].queue_free()
	health_ui_list.remove_at(index)


func set_health_ui_position(target_position: Vector2, health_ui: Control):
	health_ui.global_position = target_position + offset_position


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

