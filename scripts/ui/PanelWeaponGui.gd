extends PanelContainer
class_name PanelWeaponGui

@export var weapon_label : Label
@export var weapon_texture : TextureRect

@export var ammo_container : Node
@export var ammo_size_label : Label
@export var ammo_progress_bar : ProgressBar

@export var special_power_container : Node
@export var power_progress_bar : ProgressBar

var ammo_size : int = 0
var current_ammo_bullets : int = 0

var power_aim_value : int = 0
var current_power_value : int = 0

func set_weapon_name(name: String):
	weapon_label.text = name.replace('_', ' ')

func set_ammo_size(size: int):
	var size_str : String = str(size)
	current_ammo_bullets = size
	ammo_size = size
	ammo_size_label.text = size_str + '/' + size_str
	ammo_progress_bar.value = 100
	ammo_container.visible = true

func set_power_aim_value(aim_value: int):
	power_aim_value = aim_value
	current_power_value = 0
	power_progress_bar.value = 0
	special_power_container.visible = true


func update_ammo_on_fire():
	current_ammo_bullets -= 1
	ammo_size_label.text = str(current_ammo_bullets) + '/' + str(ammo_size)
	ammo_progress_bar.value = (float(current_ammo_bullets) / float(ammo_size)) * 100

func update_ammo_on_reload(reload_time: float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	await tween.tween_property(self.ammo_progress_bar, "value", 100, reload_time).finished
	current_ammo_bullets = ammo_size
	ammo_size_label.text = str(current_ammo_bullets) + '/' + str(ammo_size)


func update_special_power_on_use():
	current_power_value = 0
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self.power_progress_bar, "value", 0, 1)

func update_special_power_on_kill(value: int):
	current_power_value += value
	power_progress_bar.value = (float(current_power_value) / float(power_aim_value)) * 100
