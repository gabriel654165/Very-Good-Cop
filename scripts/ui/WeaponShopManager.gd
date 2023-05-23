extends Node2D
class_name WeaponShopManager

@export var active : bool = false
@export var aim_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5

@export var weapon_shop_gui : Node = null
@export var shop_container : Node = null
@export var player_infos_container : Node = null
@export var player_infos_container_parent : Node = null
@export var hover_container : Node = null
@export var buttons_container : Node = null
@export var color_rect : Node = null
@export var distance_weapon_list_parent : Node = null
@export var melee_weapon_list_parent : Node = null
@export var equipment_list_parent : Node = null

@export var item_container_scene : PackedScene
@export var player_bank_account_panel_scene : PackedScene

var gui_manager : GuiManager = null
var player_bank_account_panel : PlayerBankAccountPanel = null
var current_blur_intensity : float = 0
var shop_item_distance_weapon_list : Array[ShopItemContainer] = []
var shop_item_melee_weapon_list : Array[ShopItemContainer] = []
var shop_item_equipment_list : Array[ShopItemContainer] = []

func _ready():
	gui_manager = get_parent() as GuiManager
	shop_item_distance_weapon_list = generate_item_list_by_save(GlobalVariables.all_distance_weapon_list, GlobalVariables.player_distance_weapon_list, distance_weapon_list_parent)
	shop_item_melee_weapon_list = generate_item_list_by_save(GlobalVariables.all_melee_weapon_list, GlobalVariables.player_melee_weapon_list, melee_weapon_list_parent)
	shop_item_equipment_list = generate_item_list_by_save(GlobalVariables.all_equipment_list, GlobalVariables.player_equipment_list, equipment_list_parent)

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


func generate_item_list_by_save(all_item_infos_list, player_item_list, parent) -> Array[ShopItemContainer]:
	var item_ui_list : Array[ShopItemContainer] = []
	var index : int = 0
	
	for item_infos in all_item_infos_list:
		var item_ui = item_container_scene.instantiate()
		item_ui.weapon_manager = self
		parent.add_child(item_ui)
		item_ui_list.push_front(item_ui)
		item_ui.set_item_name(item_infos.name)
		item_ui.set_price(200)
		item_ui.item_texture.texture = item_infos.gui_texture
		item_ui.item_unlocked = player_item_list[index].unlocked
		item_ui.update()
		index += 1
	return item_ui_list

func generate_ui():
	weapon_shop_gui.visible = true
	GlobalFunctions.disable_all_game_objects(true)
	gui_manager.cursor_manager.cursor.active_mode_ui()
	gui_manager.set_active_gui_panels(false)
	gui_manager.pause_manager.disable_pause = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", aim_blur_intensity, time_to_blur)
	
	player_bank_account_panel = player_bank_account_panel_scene.instantiate()
	player_infos_container_parent.add_child(player_bank_account_panel)
	player_bank_account_panel.update()

func unload_ui():
	weapon_shop_gui.visible = false
	gui_manager.set_active_gui_panels(true)
	gui_manager.pause_manager.disable_pause = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", 0, time_to_blur)
	shop_item_distance_weapon_list = []
	shop_item_melee_weapon_list = []
	shop_item_equipment_list = []

# Signals
func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	get_tree().reload_current_scene()
