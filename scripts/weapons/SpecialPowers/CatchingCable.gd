extends SpecialPower

@export var catching_cable_scene : PackedScene
@export var projectile_size : float = 0.5

var saved_projectile_scene : PackedScene
var saved_projectile_size : float = 0
var saved_balls_by_burt : float = 0
var saved_should_bouncing : bool = false
var saved_precision : float = 0
var saved_recoil_force : float = 0

func specific_process(delta: float):
	pass

func use_special_power_child():
	saved_projectile_scene = weapon.projectile_scene
	saved_projectile_size = weapon.projectile_size
	saved_balls_by_burt = weapon.balls_by_burt
	saved_should_bouncing = weapon.projectile_should_bounce
	saved_precision = weapon.precision
	saved_recoil_force = weapon.recoil_force
	
	weapon.projectile_scene = catching_cable_scene
	weapon.projectile_size = projectile_size
	weapon.balls_by_burt = 1
	weapon.projectile_should_bounce = false
	weapon.precision = 0
	weapon.recoil_force = 0
	weapon.shoot()
	end_power()

func end_power_child():
	weapon.can_use_power = false
	weapon.projectile_scene = saved_projectile_scene
	weapon.projectile_size = saved_projectile_size
	weapon.balls_by_burt = saved_balls_by_burt
	weapon.projectile_should_bounce = saved_should_bouncing
	weapon.precision = saved_precision
	weapon.recoil_force = saved_recoil_force
