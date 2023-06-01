extends PanelManager
class_name PanelTimerManager

var running : bool = false
var time : float = 0

func stop_timer():
	running = false

func resume_timer():
	running = true

func _process(delta):
	if !running:
		return
	
	time += delta
	var format_time = "%2.2f" % [time]
	panel.set_value(str(format_time))
