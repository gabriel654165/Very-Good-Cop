extends Node2D
class_name ShadersManager

@export var colorect_chromatic : ColorRect
@export var colorect_distortion : ColorRect
@export var colorect_redial_distortion : ColorRect


func set_radial_distortion(enable: bool):
	colorect_redial_distortion.visible = enable
	
func set_colorect_distortion(enable: bool):
	colorect_distortion.visible = enable

func set_colorect_chromatic(enable: bool):
	colorect_chromatic.visible = enable
