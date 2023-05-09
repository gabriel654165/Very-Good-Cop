extends Label

var containers_slim : Array = [
	preload("res://GuiAssets/styles/containers/square/slim_panel_square.tres"),
	preload("res://GuiAssets/styles/containers/sharp/slim_panel_sharp.tres"), 
	preload("res://GuiAssets/styles/containers/round/slim_panel_round.tres"),
	preload("res://GuiAssets/styles/containers/very_round/slim_panel_v_round.tres"),
	preload("res://GuiAssets/styles/containers/pill/slim_panel_pill.tres") ]
	
var containers_normal : Array = [
	preload("res://GuiAssets/styles/containers/square/normal_panel_square.tres"),
	preload("res://GuiAssets/styles/containers/sharp/normal_panel_sharp.tres"), 
	preload("res://GuiAssets/styles/containers/round/normal_panel_round.tres"),
	preload("res://GuiAssets/styles/containers/very_round/normal_panel_v_round.tres"),
	preload("res://GuiAssets/styles/containers/pill/normal_panel_pill.tres") ]
	
var containers_focus : Array = [
	preload("res://GuiAssets/styles/containers/square/focus_square.tres"),
	preload("res://GuiAssets/styles/containers/sharp/focus_sharp.tres"), 
	preload("res://GuiAssets/styles/containers/round/focus_round.tres"),
	preload("res://GuiAssets/styles/containers/very_round/focus_v_round.tres"),
	preload("res://GuiAssets/styles/containers/pill/focus_pill.tres") ]



var _use_slim : bool = true:
	get:
		return _use_slim
	set(value):
		_use_slim = value
		_update_style()
		

var _style_index : int = 0:
	get:
		return _style_index
	set(value):
		_style_index = value
		_update_style()
	
@export var label_styles : Array[StyleBoxTexture] 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_style():
	if _use_slim:
		$ItemList.add_theme_stylebox_override("panel", containers_slim[_style_index])

	else:
		$ItemList.add_theme_stylebox_override("panel", containers_normal[_style_index])


	$ItemList.add_theme_stylebox_override("focus", containers_focus[_style_index])
	add_theme_stylebox_override("normal",label_styles[_style_index])

func _on_option_button_item_selected(index):
	_style_index = index
	
func _on_use_slim_toggled(button_pressed):
	_use_slim = button_pressed
	
func _on_item_list_focus_entered():

	var current_override = label_styles[_style_index]
	var pos_x = current_override.region_rect.position.x
	var pos_y = current_override.region_rect.position.y - current_override.region_rect.size.y 
	var size_x = current_override.region_rect.size.x
	var size_y = current_override.region_rect.size.y
	current_override.region_rect = Rect2( pos_x, pos_y, size_x, size_y )
	#current_override.region_rect.position.y -= current_override.region_rect.position.y
	pass # Replace with function body.
	
func _on_item_list_focus_exited():
	var current_override = label_styles[_style_index]
	var pos_x = current_override.region_rect.position.x
	var pos_y = current_override.region_rect.position.y + current_override.region_rect.size.y 
	var size_x = current_override.region_rect.size.x
	var size_y = current_override.region_rect.size.y
	current_override.region_rect = Rect2( pos_x, pos_y, size_x, size_y )
	pass # Replace with function body.


func _on_use_dark_cursor_check_box_toggled(button_pressed):
	
	if button_pressed:
		$ItemList.add_theme_stylebox_override("selected_focus", preload("res://GuiAssets/styles/containers/selected_focus_dark.tres"))
	else:
		$ItemList.add_theme_stylebox_override("selected_focus", preload("res://GuiAssets/styles/containers/selected_focus_light.tres"))
	pass # Replace with function body.
