extends Node2D
class_name TextPointsUiManager

@export var panel_gui : PackedScene
@export var title_panel : String

var panel : PanelGui
var current_points : int = 0

func _ready():
	panel = panel_gui.instantiate()
	add_child(panel)
	
	panel.set_title(title_panel)
	panel.set_value(str(0))

func handle_enemy_died(enemy: Enemy, points: int):
	current_points += points
	panel.set_value(str(current_points))
