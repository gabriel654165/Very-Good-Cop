extends PanelManager
class_name PanelTimerManager

var time : float = 0

func _process(delta):
	time += delta
	
	var format_time = "%2.2f" % [time]
	
	panel.set_value(str(format_time))
