extends PanelManager
class_name PanelPointsManager

var current_points : int = 0

func handle_enemy_died(enemy: Node2D, points: int):
	current_points += points
	panel.set_value(str(current_points))
