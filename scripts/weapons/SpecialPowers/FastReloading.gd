extends SpecialPower

@export var fast_reloading_cooldown : float = 0.25

var save_reloading_cooldown : float = 0.25
var save_shooting_cooldown : float = 0.25

func specific_process(delta: float):
	pass

func use_special_power_child():
	save_reloading_cooldown = weapon.reloading_cooldown
	save_shooting_cooldown = weapon.shooting_cooldown.wait_time
	
	weapon.reloading_cooldown = fast_reloading_cooldown
	if weapon.shooting_cooldown.wait_time > fast_reloading_cooldown:
		weapon.shooting_cooldown.wait_time = fast_reloading_cooldown

func end_power_child():
	weapon.reloading_cooldown = save_reloading_cooldown
	weapon.shooting_cooldown.wait_time = save_shooting_cooldown
