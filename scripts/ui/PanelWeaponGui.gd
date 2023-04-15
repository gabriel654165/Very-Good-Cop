extends PanelContainer
class_name PanelWeaponGui

@export var weapon_label : Label
@export var level_label : Label
@export var weapon_texture : TextureRect
@export var slider_power_bar : Node

var current_power_charger : float = 0

func set_weapon_name(name: String):
	weapon_label.text = name

func set_level_value(level: String):
	level_label.text = level

func set_weapon_sprite(sprite: Sprite2D):
	weapon_texture.texture = sprite.texture

func add_charge_power_bar(value: float):
	current_power_charger += value
