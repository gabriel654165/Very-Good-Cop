extends PanelContainer
class_name ShopUnlockSpecialPowerPanel

@export var name_label : Label
@export var price_label : Label
@export var obtained_container : Node
@export var buy_button : Button

var _price : int = 0
var _power_name : String = ''
var item_name : String = ''
var power_unlocked : bool = false
var power_bought : bool = false

var weapon_manager : WeaponShopManager

func set_name_label(variable_stat_name: String):
	_power_name = variable_stat_name
	name_label.text = variable_stat_name.replace('_', ' ')

func set_price(price: int):
	_price = price
	price_label.text = str(_price) + "$"

func update():
	update_player_info()
	update_buy_info()

func update_player_info():
	for player_item in GlobalVariables.player_distance_weapon_list:
		if player_item.name == item_name:
			power_bought = player_item.special_power_unlocked
			return
	for player_item in GlobalVariables.player_melee_weapon_list:
		if player_item.name == item_name:
			power_bought = player_item.special_power_unlocked
			return

func update_buy_info():
	if _price > GlobalVariables.money:
		price_label.add_theme_color_override("font_color", Color.RED)
		buy_button.modulate = Color.RED
	else:
		price_label.add_theme_color_override("font_color", Color.GREEN)
		buy_button.modulate = Color.GREEN
	
	if power_bought:
		buy_button.visible = false
		price_label.visible = false
		obtained_container.visible = true


func buy_special_power():
	if GlobalVariables.money < _price:
		return
	GlobalVariables.money -= _price
	var special_power_name : String = ''
	
	for player_item in GlobalVariables.player_distance_weapon_list:
		if player_item.name == item_name:
			player_item.special_power_unlocked = true
			break
	for player_item in GlobalVariables.player_melee_weapon_list:
		if player_item.name == item_name:
			player_item.special_power_unlocked = true
			break
	
	if weapon_manager != null:
		weapon_manager.update()


# Signals
func _on_buy_button_pressed():
	buy_special_power()
	if weapon_manager != null:
		weapon_manager.unload_hover()
		weapon_manager.load_hover(item_name, _power_name)


func _on_mouse_entered():
	if weapon_manager != null:
		weapon_manager.unload_hover()
		weapon_manager.load_hover(item_name, _power_name)


func _on_mouse_exited():
	if weapon_manager != null:
		weapon_manager.unload_hover()


func _on_buy_button_mouse_entered():
	if weapon_manager != null:
		weapon_manager.unload_hover()
		weapon_manager.load_hover(item_name, _power_name)


func _on_buy_button_mouse_exited():
	if weapon_manager != null:
		weapon_manager.unload_hover()
