extends Node2D
class_name DetectableTarget

func _enter_tree():
	DetectableTargetManager.register(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _exit_tree():
	DetectableTargetManager.deregister(self)
