extends PanelContainer
class_name ItemDescriptionPanel

@export var description_label : Label

func set_description(description: String):
	description_label.text = description
