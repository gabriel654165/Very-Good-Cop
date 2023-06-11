extends Node2D
class_name WeaponShopManager

@export var active : bool = false
@export var aim_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5

@export var weapon_shop_gui : Node = null
@export var shop_container : Node = null
@export var weapon_tab_container : TabContainer = null
@export var player_infos_container : Node = null
@export var player_infos_container_parent : Node = null
@export var hover_container : Node = null
@export var hover_panel_parent : Node = null
@export var buttons_container : AspectRatioContainer = null
@export var color_rect : Node = null
@export var distance_weapon_list_parent : Node = null
@export var melee_weapon_list_parent : Node = null
@export var equipment_list_parent : Node = null

@export var item_container_scene : PackedScene
@export var player_bank_account_panel_scene : PackedScene
@export var stats_panel_scene : PackedScene
@export var preview_panel_scene : PackedScene
@export var description_panel_scene : PackedScene

var gui_manager : GuiManager = null
var player_bank_account_panel : PlayerBankAccountPanel = null
var stats_panel : ItemStatsPanel = null
var preview_panel : ItemPreviewPanel = null
var description_panel : ItemDescriptionPanel = null
var current_blur_intensity : float = 0
var shop_item_distance_weapon_list : Array[ShopItemContainer] = []
var shop_item_melee_weapon_list : Array[ShopItemContainer] = []
var shop_item_equipment_list : Array[ShopItemContainer] = []


func _ready():
	gui_manager = get_parent() as GuiManager


func _process(delta):
	if (active and current_blur_intensity < aim_blur_intensity) or (!active and current_blur_intensity > 0):
		color_rect.get_material().set_shader_parameter("intensity", current_blur_intensity)


func set_active(state: bool):
	if weapon_shop_gui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()


func update():
	for distance_weapon_item in shop_item_distance_weapon_list:
		distance_weapon_item.update()
	for melee_weapon_item in shop_item_melee_weapon_list:
		melee_weapon_item.update()
	for equipment_item in shop_item_equipment_list:
		equipment_item.update()
	player_bank_account_panel.update()


func generate_item_list_by_save(all_item_infos_list, player_item_list, equiped_item_index, parent) -> Array[ShopItemContainer]:
	var item_ui_list : Array[ShopItemContainer] = []
	var index : int = 0
	
	for item_infos in all_item_infos_list:
		var item_ui = item_container_scene.instantiate()
		item_ui.weapon_manager = self
		parent.add_child(item_ui)
		item_ui_list.push_front(item_ui)
		item_ui.set_item_name(item_infos.name)
		item_ui.set_price(200)
		if equiped_item_index == index:
			item_ui.equiped_label.visible = true
		item_ui.item_texture.texture = item_infos.gui_texture
		item_ui.item_unlocked = player_item_list[index].unlocked
		item_ui.update()
		index += 1
	return item_ui_list

func load_stat_hover(item_name: String, stat_name: String):
	stats_panel = stats_panel_scene.instantiate()
	hover_panel_parent.add_child(stats_panel)
	stats_panel.item_name = item_name
	stats_panel.stat_upgrade_name = stat_name
	stats_panel.generate_ui()

func load_preview_hover(item_name: String, preview_path: String):
	preview_panel = preview_panel_scene.instantiate()
	hover_panel_parent.add_child(preview_panel)
	for item in GlobalVariables.all_distance_weapon_list:
		if item.name == item_name:
			preview_panel.set_preview(item.special_power_preview)
			return
	for item in GlobalVariables.all_melee_weapon_list:
		if item.name == item_name:
			preview_panel.set_preview(item.special_power_preview)
			return

func load_description_hover(item_name: String, preview_path: String):
	description_panel = description_panel_scene.instantiate()
	hover_panel_parent.add_child(description_panel)
	for item in GlobalVariables.all_distance_weapon_list:
		if item.name == item_name:
			description_panel.set_description(item.special_power_description)
			return
	for item in GlobalVariables.all_melee_weapon_list:
		if item.name == item_name:
			description_panel.set_description(item.special_power_description)
			return

func load_hover(item_name: String, property_name: String = ""):
	for item in GlobalVariables.all_distance_weapon_list:
		if item.name == item_name:
			load_stat_hover(item_name, property_name)
		if item.special_power_name == property_name:
			if stats_panel != null:
				stats_panel.queue_free()
			load_description_hover(item_name, item.special_power_description)
			load_preview_hover(item_name, item.special_power_preview)
			return
	for item in GlobalVariables.all_melee_weapon_list:
		if item.name == item_name:
			load_stat_hover(item_name, property_name)
		if item.special_power_name == property_name:
			if stats_panel != null:
				stats_panel.queue_free()
			load_description_hover(item_name, item.special_power_description)
			load_preview_hover(item_name, item.special_power_preview)
			return

func unload_hover():
	if stats_panel != null:
		stats_panel.queue_free()
	if preview_panel != null:
		preview_panel.queue_free()
	if description_panel != null:
		description_panel.queue_free()


func load_item_panels():
	shop_item_distance_weapon_list = generate_item_list_by_save(GlobalVariables.all_distance_weapon_list, GlobalVariables.player_distance_weapon_list, GlobalVariables.index_distance_weapon_selected, distance_weapon_list_parent)
	shop_item_melee_weapon_list = generate_item_list_by_save(GlobalVariables.all_melee_weapon_list, GlobalVariables.player_melee_weapon_list, GlobalVariables.index_melee_weapon_selected, melee_weapon_list_parent)
	
	shop_item_equipment_list = generate_item_list_by_save(GlobalVariables.all_equipment_list, GlobalVariables.player_equipment_list, -1, equipment_list_parent)

func load_account_panel():
	player_bank_account_panel = player_bank_account_panel_scene.instantiate()
	player_infos_container_parent.add_child(player_bank_account_panel)
	player_bank_account_panel.update()

func generate_ui():
	weapon_shop_gui.visible = true
	weapon_tab_container.visible = true
	weapon_tab_container.current_tab = 0
	buttons_container.visible = true
	GlobalFunctions.disable_all_game_objects(true)
	gui_manager.cursor_manager.cursor.active_mode_ui()
	gui_manager.set_active_gui_panels(false)
	gui_manager.pause_manager.disable_pause = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", aim_blur_intensity, time_to_blur)
	load_item_panels()
	load_account_panel()

func unload_ui():
	weapon_shop_gui.visible = false
	weapon_tab_container.visible = false
	buttons_container.visible = false
	GlobalFunctions.disable_all_game_objects(false)
	gui_manager.set_active_gui_panels(true)
	gui_manager.pause_manager.disable_pause = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", 0, time_to_blur)
	if player_bank_account_panel != null:
		player_bank_account_panel.queue_free()
	free_item_panel_list(shop_item_distance_weapon_list)
	free_item_panel_list(shop_item_melee_weapon_list)
	free_item_panel_list(shop_item_equipment_list)

func free_item_panel_list(item_panel_list: Array):
	for item in item_panel_list:
		if item != null:
			item.queue_free()

# Signals
func _on_quit_button_pressed():
	get_tree().quit()

#TODO : SAVE HERE
func _on_continue_button_pressed():
	GlobalVariables.level += 1
	get_tree().reload_current_scene()
