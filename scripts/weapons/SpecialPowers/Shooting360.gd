extends SpecialPower

@onready var target = $Target

@export var time_between_shoots : float = 0.001
@export var full_rotation_by_second : float = 2

var save_recoil_force : float = 0
var save_player_speed : float = 0

var is_shooting : bool = false
var timer_between_shoots : float = 0
var rotation_angle : float = 0

func specific_process(delta: float):
	timer_between_shoots += delta
	if timer_between_shoots >= time_between_shoots:
		weapon.shoot()
		timer_between_shoots = 0
	
	player.global_rotation_degrees = rotation_angle
	rotation_angle += 360 * delta * full_rotation_by_second

func use_special_power_child():
	is_shooting = true
	disable_look_at = true
	save_recoil_force = weapon.recoil_force
	save_player_speed = player.speed
	player.speed = 0
	weapon.recoil_force = 0

	target.global_position = get_viewport_transform().affine_inverse() * GlobalVariables.cursor_position
	rotation_angle = target.global_rotation_degrees
	player.global_rotation_degrees = rotation_angle

func end_power_child():
	is_shooting = false
	disable_look_at = false
	weapon.recoil_force = save_recoil_force
	player.speed = save_player_speed
