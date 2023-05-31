extends Node2D
class_name ShadersManager

@export var colorect_chromatic : ColorRect
@export var colorect_distortion : ColorRect
@export var colorect_radial_distortion : ColorRect

@export var shader_animation_player : AnimationPlayer


func update_visibility_chromatic_colorect():
	colorect_chromatic.visible = !colorect_chromatic.visible

func set_colorect_chromatic(enable: bool):
	var speed : float = 1.0 if enable else -1.0
	shader_animation_player.play("chromatic_shader_enable", -1, speed, !enable)


func update_visibility_distortion_colorect():
	colorect_distortion.visible = !colorect_distortion.visible

func set_colorect_distortion(enable: bool):
	var speed : float = 1.0 if enable else -1.0
	shader_animation_player.play("distortion_shader_enable", -1, speed, !enable)


func update_visibility_radial_distortion_colorect():
	colorect_radial_distortion.visible = !colorect_radial_distortion.visible

func set_colorect_radial_distortion(enable: bool):
	var speed : float = 1.0 if enable else -1.0
	shader_animation_player.play("radial_distortion_shader_enable", -1, speed, !enable)
