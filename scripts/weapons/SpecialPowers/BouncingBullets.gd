extends SpecialPower

func specific_process(delta: float):
	pass

func use_special_power_child():
	weapon.projectile_should_bounce = true

func end_power_child():
	weapon.projectile_should_bounce = false
