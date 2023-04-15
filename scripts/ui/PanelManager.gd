extends Node2D
class_name PanelManager

@export var panel_gui : PackedScene
@export var title_panel : String
@export var panels_container : Control

var panel : PanelGui

func _ready():
	panel = panel_gui.instantiate()
	panels_container.add_child(panel)
	
	panel.set_title(title_panel)
	panel.set_value(str(0))
