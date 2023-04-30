extends SpecialPower

func specific_process(delta: float):
	pass

func use_special_power():
	activated = true
	weapon.bullet_should_pierce_walls = true

func end_power():
	activated = false
	weapon.bullet_should_pierce_walls = false
