extends CPUParticles2D
class_name Blood

func _on_timer_timeout():
	GlobalFunctions.disable_all_process(self, true)
