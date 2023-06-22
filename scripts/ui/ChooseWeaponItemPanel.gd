extends PanelContainer
class_name ChooseWeaponItemPanel

@export var item_texture : TextureRect
@export var item_check_box : CheckBox
@export var item_name_label : Label

var item_name : String
var item_global_index : int
var weapon_manager : ChooseWeaponManager
var selected : bool = false

func set_item_name(name: String):
	item_name = name
	item_name_label.text = item_name.replace('_', ' ')

# Signals
func _on_check_box_toggled(button_pressed: bool):
	if selected:
		item_check_box.button_pressed = true
		return
	
	if button_pressed:
		selected = true
		for item in GlobalVariables.player_distance_weapon_list:
			if item.name == item_name:
				GlobalVariables.index_distance_weapon_selected = item_global_index
		for item in GlobalVariables.player_melee_weapon_list:
			if item.name == item_name:
				GlobalVariables.index_melee_weapon_selected = item_global_index
		for item in GlobalVariables.player_throwable_object_list:
			if item.name == item_name:
				GlobalVariables.index_throwable_object_selected = item_global_index
		
		weapon_manager.update_selected_weapon()
