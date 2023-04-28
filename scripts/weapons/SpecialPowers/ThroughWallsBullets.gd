extends SpecialPower

func specific_process(delta: float):
	pass

func end_power():
	activated = false
	weapon.bullet_should_pierce_walls = false
	print("throughWalls bullets power no more active")

func use_special_power():
	activated = true
	weapon.bullet_should_pierce_walls = true
	print("use throughWalls bullets")
