extends HBoxContainer
class_name PropertyStatContainer

@export var name_label : Label
@export var value_label : Label 
@export var value_checkbox : CheckBox 

@export var compare_value_label_container : Node
@export var compare_value_checkbox_container : Node

@export var compare_value_label : Label
@export var compare_checkbox : CheckBox
@export var compare_checkbox_label : Label

var stat_name : String
var stat_value


func set_stat_name(name: String):
	stat_name = name
	name_label.text = name.replace('_', ' ') + " :"


func set_stat_value(value):
	if value is bool:
		stat_value = value
		value_checkbox.button_pressed = value
		value_checkbox.visible = true
	elif value is int or value is float:
		stat_value = value
		value_label.text = str(snapped(value, 0.01))
		value_label.visible = true


func set_compare_value(to_compare_value):
	if to_compare_value == stat_value:
		return
	
	var color : Color = Color.WHITE
	
	if to_compare_value is bool:
		compare_value_checkbox_container.visible = true
		if to_compare_value and !stat_value:
			color = Color.RED
		elif !to_compare_value and stat_value:
			color = Color.GREEN
		compare_checkbox_label.add_theme_color_override("font_color", color)
		compare_checkbox.button_pressed = to_compare_value
	
	elif to_compare_value is int or to_compare_value is float:
		var compare_operator : String = ""
		
		compare_value_label_container.visible = true
		if to_compare_value < stat_value:
			compare_operator = "+"
			color = Color.GREEN
			to_compare_value = stat_value - to_compare_value
		elif to_compare_value > stat_value:
			compare_operator = "-"
			color = Color.RED
			to_compare_value = to_compare_value - stat_value
		compare_value_label.add_theme_color_override("font_color", color)
		compare_value_label.text = compare_operator + str(snapped(to_compare_value, 0.01))
		
	
