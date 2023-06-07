extends CanvasLayer
class_name ScreenEffectManager

@onready var shaders_manager : ShadersManager = $ShadersManager


# TODO : animation of heal and after visible = false, enable not needed
func set_heal_power_up(enable: bool):
	pass

func set_damage_power_up(enable: bool):
	pass

func set_speed_power_up(enable: bool):
	shaders_manager.set_colorect_radial_distortion(enable)

func set_slowmotion_power_up(enable: bool):
	shaders_manager.set_colorect_distortion(enable)

# TODO : display entiere minimap with arrival room
func set_minimap_power_up(enable: bool):
	shaders_manager.set_colorect_chromatic(enable)
