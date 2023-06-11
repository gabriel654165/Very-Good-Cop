extends Node2D
class_name PopUpPowerUpManager

@export var pop_up_text_scene : PackedScene

@export var life_time : float = 1
@export var text_scale : Vector2 = Vector2(5, 5)

@export var velocity_mov : Vector2 = Vector2(0, -10)
@export var velocity_scale : Vector2 = Vector2(60, 60)

#slow motion
@export var slow_motion_color_text_under : Color = Color.DARK_GREEN
@export var slow_motion_color_text_upper : Color = Color.GREEN_YELLOW
#heal
@export var heal_color_text_under : Color = Color.DARK_RED
@export var heal_color_text_upper : Color = Color.LIGHT_SLATE_GRAY
#speed
@export var speed_color_text_under : Color = Color.BLUE
@export var speed_color_text_upper : Color = Color.DARK_VIOLET
#damages
@export var damages_color_text_under : Color = Color.DARK_RED
@export var damages_color_text_upper : Color = Color.ORANGE_RED
#minimap extend
@export var minimap_extend_color_text_under : Color = Color.DEEP_PINK
@export var minimap_extend_color_text_upper : Color = Color.CORAL

func set_pop_up(pop_up: PopUpText, content: String, color_text_under: Color, color_text_upper: Color):
	pop_up.set_content(content)
	pop_up.text_upper.set("theme_override_colors/font_color", color_text_under)
	pop_up.text_under.set("theme_override_colors/font_color", color_text_upper)


func handle_power_up_taken(power_up: PassiveEffect):
	var pop_up_text_instance = pop_up_text_scene.instantiate()
	add_child(pop_up_text_instance)
	
	pop_up_text_instance.scale = text_scale
	pop_up_text_instance.set_life_time(life_time)
	
	pop_up_text_instance.velocity_mov = velocity_mov
	pop_up_text_instance.velocity_scale = velocity_scale
	
	match power_up.type:
		PassiveEffect.TYPE.SLOW_MOTION:
			set_pop_up(pop_up_text_instance, "SLOW MOTION", slow_motion_color_text_under, slow_motion_color_text_upper)
		PassiveEffect.TYPE.HEAL:
			set_pop_up(pop_up_text_instance, "HEAL", heal_color_text_under, heal_color_text_upper)
		PassiveEffect.TYPE.SPEED:
			set_pop_up(pop_up_text_instance, "SPEED UP", speed_color_text_under, speed_color_text_upper)
		PassiveEffect.TYPE.DAMAGE:
			set_pop_up(pop_up_text_instance, "EXTRA DAMAGES", damages_color_text_under, damages_color_text_upper)
		PassiveEffect.TYPE.MINIMAP_EXTEND:
			set_pop_up(pop_up_text_instance, "EXTRA VISION", minimap_extend_color_text_under, minimap_extend_color_text_upper)
	
	pop_up_text_instance.life_timer.start()
