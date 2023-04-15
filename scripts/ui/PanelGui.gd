extends ColorRect
class_name PanelGui

@onready var title_panel = $PanelContainer/VSplitContainer/LabelTitle
@onready var value_panel = $PanelContainer/VSplitContainer/LabelValue

func set_title(title: String):
	title_panel.text = title

func set_value(value: String):
	value_panel.text = value
