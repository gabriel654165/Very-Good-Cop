extends PanelContainer
class_name PanelWeaponGui

@export var weapon_label : Label
@export var level_label : Label
@export var weapon_texture : TextureRect
@export var slider_power_bar : Node

var current_power_charger : float = 0

func set_weapon_name(name: String):
	weapon_label.text = name.replace('_', ' ')

func reset_current_power_charger():
	current_power_charger = 0

func add_charge_power_bar(value: float):
	current_power_charger += value
