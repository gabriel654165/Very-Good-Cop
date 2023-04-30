extends SpecialPower

func specific_process(delta: float):
	pass

func use_special_power_child():
	weapon.bullet_should_pierce_walls = true

func end_power_child():
	weapon.bullet_should_pierce_walls = false
