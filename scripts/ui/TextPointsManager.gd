extends PanelManager
class_name PanelPointsManager

var current_points : int = 0

func handle_enemy_died(enemy: Enemy, points: int):
	current_points += points
	panel.set_value(str(current_points))
