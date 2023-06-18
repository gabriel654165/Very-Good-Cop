extends PanelContainer
class_name ShopItemContainer

@export var item_texture : TextureRect
@export var item_name_label : Label
@export var unlock_item_container : Node
@export var buy_item_button : Button
@export var buy_item_price_label : Label
@export var upgrade_properties_container : Node
@export var equiped_label : Label

@export var property_list_panel : PanelContainer
@export var special_power_list_panel : PanelContainer
@export var property_list_parent : Node
@export var special_power_list_parent : Node

@export var upgrade_item_stat_panel_scene : PackedScene
@export var special_power_panel_scene : PackedScene

var item_unlocked : bool = false
var item_name : String
var _price : int = 0
var shop_item_property_list : Array[ShopUpgradeItemStatPanel] = []
var shop_item_special_power : ShopUnlockSpecialPowerPanel
var weapon_manager : WeaponShopManager = null

func set_item_name(ref_name: String):
	item_name = ref_name
	item_name_label.text = ref_name.replace('_', ' ')

func set_price(price: int):
	_price = price
	buy_item_price_label.text = str(_price) + '$'


func update():
	update_buying_panel()
	if !item_unlocked:
		update_buy_item_panel()
	else:
		unload_upgrade_properties_panel()
		generate_upgrade_properties_panel()
		unload_special_power_panel()
		generate_special_power_panel()


func update_buy_item_panel():
	if _price > GlobalVariables.money:
		buy_item_price_label.add_theme_color_override("font_color", Color.RED)
		buy_item_button.modulate = Color.RED
	else:
		buy_item_price_label.add_theme_color_override("font_color", Color.GREEN)
		buy_item_button.modulate = Color.GREEN

func update_buying_panel():
	if !item_unlocked:
		unlock_item_container.visible = true
		upgrade_properties_container.visible = false
	else:
		unlock_item_container.visible = false
		upgrade_properties_container.visible = true


func generate_property_list_by_save(ref_item_stats_list, player_item_stats_list, parent) -> Array[ShopUpgradeItemStatPanel]:
	var item_property_list : Array[ShopUpgradeItemStatPanel]
	var index : int = 0
	
	for key in player_item_stats_list:
		var value = player_item_stats_list[key]
		
		if value is String or value is bool:
			continue
		if value != -1:
			var upgrade_item_stat_panel_ui = upgrade_item_stat_panel_scene.instantiate()
			var ref_item_stat : Dictionary

			item_property_list.push_front(upgrade_item_stat_panel_ui)
			parent.add_child(upgrade_item_stat_panel_ui)
			
			for ref_item in ref_item_stats_list:
				if ref_item.keys()[0] == key.trim_suffix("_lvl"):
					ref_item_stat = ref_item
			
			var ref_list_key = ref_item_stat.keys()[0]
			var stat_max_lvl = ref_item_stat[ref_list_key].number_of_levels
			upgrade_item_stat_panel_ui.set_name_label(ref_list_key)
			upgrade_item_stat_panel_ui.item_name = item_name
			upgrade_item_stat_panel_ui.weapon_manager = weapon_manager
			upgrade_item_stat_panel_ui.set_level_label(value, stat_max_lvl)
			upgrade_item_stat_panel_ui.set_price(100)
			upgrade_item_stat_panel_ui.update()
		
		index += 1
	return item_property_list

func generate_upgrade_properties_panel():
	#repetition
	var index : int = 0
	for item_ref in GlobalVariables.all_distance_weapon_list:
		if item_ref.name == item_name:
			shop_item_property_list = generate_property_list_by_save(item_ref.stats, GlobalVariables.player_distance_weapon_list[index], property_list_parent)
			return
		index += 1
	index = 0
	
	#repetition
	for item_ref in GlobalVariables.all_melee_weapon_list:
		if item_ref.name == item_name:
			shop_item_property_list = generate_property_list_by_save(item_ref.stats, GlobalVariables.player_melee_weapon_list[index], property_list_parent)
			return
		index += 1
	index = 0
	
	#repetition
	for item_ref in GlobalVariables.all_equipment_list:
		if item_ref.name == item_name:
			shop_item_property_list = generate_property_list_by_save(item_ref.stats, GlobalVariables.player_equipment_list[index], property_list_parent)
			return
		index += 1
	
	property_list_panel.visible = false

func unload_upgrade_properties_panel():
	for item_property in shop_item_property_list:
		item_property.queue_free()

func generate_special_power_panel():
	var special_power_name
	
	for item in GlobalVariables.all_distance_weapon_list:
		if item.name == item_name:
			special_power_name = item.special_power_name
	for item in GlobalVariables.all_melee_weapon_list:
		if item.name == item_name:
			special_power_name = item.special_power_name
	if special_power_name == null:
		special_power_list_panel.visible = false
		return

	shop_item_special_power = special_power_panel_scene.instantiate()
	special_power_list_parent.add_child(shop_item_special_power)
	shop_item_special_power.set_name_label(special_power_name)
	shop_item_special_power.item_name = item_name
	shop_item_special_power.weapon_manager = weapon_manager
	shop_item_special_power.set_price(100)
	shop_item_special_power.update()


func unload_special_power_panel():
	if shop_item_special_power != null:
		shop_item_special_power.queue_free()

func buy_item():
	if GlobalVariables.money < _price:
		return
	GlobalVariables.money -= _price
	for player_item in GlobalVariables.player_distance_weapon_list:
		if player_item.name == item_name:
			player_item.unlocked = true
	for player_item in GlobalVariables.player_melee_weapon_list:
		if player_item.name == item_name:
			player_item.unlocked = true
	for player_item in GlobalVariables.player_equipment_list:
		if player_item.name == item_name:
			player_item.unlocked = true
	item_unlocked = true
	if weapon_manager != null:
		weapon_manager.update()

#signals
func _on_buy_button_pressed():
	buy_item()

func _on_mouse_entered():
	if weapon_manager != null:
		weapon_manager.load_hover(item_name)

func _on_mouse_exited():
	if weapon_manager != null:
		weapon_manager.unload_hover()
