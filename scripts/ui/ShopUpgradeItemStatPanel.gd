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

func set_level_label(current_lvl: int, max_lvl: int):
	_current_item_level = _current_item_level
	_max_item_level = max_lvl
	level_label.text = str(current_lvl) + "/" + str(max_lvl)

func set_name_label(variable_stat_name: String):
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
