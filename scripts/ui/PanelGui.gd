extends PanelContainer
class_name PanelGui

@export var title_label : Label
@export var value_label : Label

func set_title(title: String):
	title_label.text = title

func set_value(value: String):
	value_label.text = value
