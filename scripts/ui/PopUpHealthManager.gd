extends Node2D
class_name PopUpHealthManager

@export var pop_up_text_scene : PackedScene

@export var life_time : float = 1
@export var enemy_offset : Vector2 = Vector2(5, -60)
@export var text_scale : Vector2 = Vector2(1, 1)

@export var velocity_mov : Vector2 = Vector2(0, -10)
@export var velocity_scale : Vector2 = Vector2(1.5, 1.5)

func handle_character_health_changed(health: Health, value: float):
	#print("health changed on : ", health.get_parent().name)
	var parent = health.get_parent()
	
	if parent == null:
		return

	var pop_up_text_instance = pop_up_text_scene.instantiate()
	add_child(pop_up_text_instance)
	
	pop_up_text_instance.set_world_target(parent)
	pop_up_text_instance.enemy_base_offset = enemy_offset
	pop_up_text_instance.scale = text_scale
	pop_up_text_instance.set_life_time(life_time)
	
	pop_up_text_instance.velocity_mov = velocity_mov
	pop_up_text_instance.velocity_scale = velocity_scale
	
	if value > 0:
		pop_up_text_instance.set_content("+" + str(value))
	elif value < 0:
		pop_up_text_instance.set_content(str(value))

	pop_up_text_instance.life_timer.start()
	
