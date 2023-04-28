extends SpecialPower

func specific_process(delta: float):
	pass

func end_power():
	activated = false
	print("aim bot power no more active")

func use_special_power():
	activated = true
	print("use aim bot")
