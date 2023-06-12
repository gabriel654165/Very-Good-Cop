extends PanelManager
class_name PanelPowerUpsManager

var current_power_ups_taken : int = 0

func handle_power_up_taken(power_up: PassiveEffect):
	current_power_ups_taken += 1
	panel.set_value(str(current_power_ups_taken))
