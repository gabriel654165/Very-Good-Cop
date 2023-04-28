extends SpecialPower

func specific_process(delta: float):
	pass

func end_power():
	activated = false
	print("catching cable power no more active")

func use_special_power():
	activated = true
	print("use catching cable")
