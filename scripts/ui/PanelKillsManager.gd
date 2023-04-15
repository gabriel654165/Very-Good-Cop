extends PanelManager
class_name PanelKillManager

var current_kills : int = 0

func handle_enemy_died(enemy: Enemy, points: int):
	current_kills += 1
	panel.set_value(str(current_kills))
