extends SpecialPower

func specific_process(delta: float):
	pass

func end_power():
	activated = false
	weapon.bullet_should_bounce = false
	print("bouncing bullets power no more active")

func use_special_power():
	activated = true
	weapon.bullet_should_bounce = true
	print("use bouncing bullets")
