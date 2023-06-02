extends Node2D
class_name ScreenEffectsManager

@export var colorect_chromatic : ColorRect
@export var colorect_distortion : ColorRect
@export var colorect_redialdistortion : ColorRect

# TODO : animation of heal and after visible = false, enable not needed
func set_heal_power_up(enable: bool):
	pass

func set_damage_power_up(enable: bool):
	pass

func set_speed_power_up(enable: bool):
	colorect_redialdistortion.visible = enable

func set_slowmotion_power_up(enable: bool):
	colorect_distortion.visible = enable

# TODO : display entiere minimap with arrival room
func set_minimap_power_up(enable: bool):
	colorect_chromatic.visible = enable
