extends PanelContainer
class_name PlayerBankAccountPanel

@export var money_value_label : Label
@export var account_log_container_parent : Node
@export var account_log_total_container : Node

@export var account_log_container_scene : PackedScene

func set_money_value(value: int):
	money_value_label.text = str(value) + '$' 

func _ready():
	set_money_value(GlobalVariables.money)

func update_money_value_label_color():
	if GlobalVariables.money <= 0:
		money_value_label.add_theme_color_override("font_color", Color.RED)
	else:
		money_value_label.add_theme_color_override("font_color", Color.GREEN)

func update():
	set_money_value(GlobalVariables.money)
	update_money_value_label_color()
