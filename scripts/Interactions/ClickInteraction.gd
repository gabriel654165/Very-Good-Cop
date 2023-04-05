extends Interaction

func _input(event):
	if !is_active:
		return
	if event is InputEventMouseButton:
		print("interaction : click = TRUE")
		is_triggered = true
	else:
		is_triggered = false
