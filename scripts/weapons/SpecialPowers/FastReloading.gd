extends SpecialPower

@export var fast_reloading_cooldown : float = 0.25

var save_ammo_reloading_time : float = 0.25
var save_shooting_cooldown : float = 0.25

func specific_process(delta: float):
	pass

func use_special_power_child():
	save_ammo_reloading_time = weapon.ammo_reloading_time
	save_shooting_cooldown = weapon.shooting_cooldown.wait_time
	
	weapon.ammo_reloading_time = fast_reloading_cooldown
	if weapon.shooting_cooldown.wait_time > fast_reloading_cooldown:
		weapon.shooting_cooldown.wait_time = fast_reloading_cooldown

func end_power_child():
	weapon.ammo_reloading_time = save_ammo_reloading_time
	weapon.shooting_cooldown.wait_time = save_shooting_cooldown
