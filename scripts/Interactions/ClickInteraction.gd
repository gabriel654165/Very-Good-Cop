extends Interaction

var clicked:bool

#func process(data:Dictionary):
#	data["ClickInteraction"]["cliked"] = clicked

func _input(event):
	if !is_active:
		return
	if event is InputEventMouseButton:
		is_triggered = true
	else:
		is_triggered = false
