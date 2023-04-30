extends SpecialPower

func specific_process(delta: float):
	pass

func use_special_power():
	activated = true
	weapon.bullet_should_bounce = true

func end_power():
	activated = false
	weapon.bullet_should_bounce = false
