extends PanelContainer
class_name ShopUpgradeItemStatPanel

@export var icon_texture : TextureRect
@export var name_label : Label
@export var level_label : Label
@export var max_level_container : Node
@export var upgrade_button : Button
@export var price_label : Label

var _price : int = 0
var _current_item_level : int = 0
var _max_item_level : int = 0
var _property_name : String = ''
var item_name : String = ''
var weapon_manager : WeaponShopManager

func set_level_label(current_lvl: int, max_lvl: int):
	_current_item_level = current_lvl
	_max_item_level = max_lvl
	level_label.text = str(_current_item_level) + "/" + str(_max_item_level)

func set_name_label(variable_stat_name: String):
	_property_name = variable_stat_name
	name_label.text = variable_stat_name.replace('_', ' ')

func set_price(price: int):
	_price = price
	price_label.text = str(_price) + "$"


func update():
	update_buy_info()

func update_buy_info():
	if _price > GlobalVariables.money:
		price_label.add_theme_color_override("font_color", Color.RED)
		upgrade_button.modulate = Color.RED
	else:
		price_label.add_theme_color_override("font_color", Color.GREEN)
		upgrade_button.modulate = Color.GREEN
	
	if _current_item_level == _max_item_level:
		upgrade_button.visible = false
		price_label.visible = false
		max_level_container.visible = true

func upgrade_property():
	if GlobalVariables.money < _price:
		return
	GlobalVariables.money -= _price
	
	for player_item in GlobalVariables.player_distance_weapon_list:
		if player_item.name == item_name:
			player_item[_property_name + '_lvl'] += 1
			break
	for player_item in GlobalVariables.player_melee_weapon_list:
		if player_item.name == item_name:
			player_item[_property_name + '_lvl'] += 1
			break
	for player_item in GlobalVariables.player_equipment_list:
		if player_item.name == item_name:
			player_item[_property_name + '_lvl'] += 1
			break
	
	if weapon_manager != null:
		weapon_manager.update()


#signals
func _on_upgrade_button_pressed():
	upgrade_property()
	if weapon_manager != null:
		weapon_manager.unload_hover()
		weapon_manager.load_hover(item_name, _property_name)

func _on_mouse_entered():
	if weapon_manager != null:
		weapon_manager.unload_hover()
		weapon_manager.load_hover(item_name, _property_name)

func _on_mouse_exited():
	if weapon_manager != null:
		weapon_manager.unload_hover()

func _on_upgrade_button_mouse_entered():
	if weapon_manager != null:
		weapon_manager.unload_hover()
		weapon_manager.load_hover(item_name, _property_name)

func _on_upgrade_button_mouse_exited():
	if weapon_manager != null:
		weapon_manager.unload_hover()
