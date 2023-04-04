extends Interaction

@export var keyCode : Key = KEY_NONE

func _input(event):
	if !is_active:
		return
	if Input.is_key_pressed(keyCode):
		print("interaction : press = TRUE")
		is_triggered = true
	else:
		is_triggered = false
