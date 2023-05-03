extends SpecialPower

@export var frag_projectile_precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
@export var frag_projectile_precision : float = 1
@export var number_of_frag_projectile : int = 3

var save_frag_projectile_precision_angle : Vector2 = Vector2(-1, 1)
var save_frag_projectile_precision : float = 1
var save_number_of_frag_projectile : int = 3

func specific_process(delta: float):
	pass

func use_special_power_child():
	save_frag_projectile_precision_angle = weapon.frag_projectile_precision_angle
	save_frag_projectile_precision = weapon.frag_projectile_precision
	save_number_of_frag_projectile = weapon.number_of_frag_projectile
	
	weapon.projectile_should_frag = true
	weapon.frag_projectile_precision_angle = frag_projectile_precision_angle
	weapon.frag_projectile_precision = frag_projectile_precision
	weapon.number_of_frag_projectile = number_of_frag_projectile

func end_power_child():
	weapon.projectile_should_frag = false
	
	weapon.frag_projectile_precision_angle = save_frag_projectile_precision_angle
	weapon.frag_projectile_precision = save_frag_projectile_precision
	weapon.number_of_frag_projectile = save_number_of_frag_projectile
