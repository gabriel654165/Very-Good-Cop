extends SpecialPower

@export var catching_cable_scene : PackedScene
@export var projectile_size : float = 0.5

var saved_projectile_scene : PackedScene
var saved_projectile_size : float = 0
var saved_number_of_balls_by_burt : float = 0
var saved_should_bouncing : bool = false
var saved_precision : float = 0
var saved_recoil_force : float = 0

func specific_process(delta: float):
	pass

func use_special_power_child():
	saved_projectile_scene = weapon.projectile_scene
	saved_projectile_size = weapon.bullet_size
	saved_number_of_balls_by_burt = weapon.number_of_balls_by_burt
	saved_should_bouncing = weapon.bullet_should_bounce
	saved_precision = weapon.precision
	saved_recoil_force = weapon.recoil_force
	
	weapon.projectile_scene = catching_cable_scene
	weapon.bullet_size = projectile_size
	weapon.number_of_balls_by_burt = 1
	weapon.bullet_should_bounce = false
	weapon.precision = 0
	weapon.recoil_force = 0
	weapon.shoot()
	end_power()

func end_power_child():
	weapon.can_use_power = false
	weapon.projectile_scene = saved_projectile_scene
	weapon.bullet_size = saved_projectile_size
	weapon.number_of_balls_by_burt = saved_number_of_balls_by_burt
	weapon.bullet_should_bounce = saved_should_bouncing
	weapon.precision = saved_precision
	weapon.recoil_force = saved_recoil_force
