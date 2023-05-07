extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	var help_menu : MenuButton = $MenuBar/MenuButton3
	var popup : Popup = help_menu.get_popup()
	popup.id_pressed.connect(on_help_menu_item_pressed)
	#$MenuBar/MenuButton3.get_popup()
	pass # Replace with function body.

func on_help_menu_item_pressed(id):
	print( "pressed: " + str(id) )
	$Popup/PopupPanel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_h_slider_value_changed(value = 50):
	var slider : HSlider = $HSlider
	if value == slider.max_value:
		slider.tooltip_text = "Weapons at maximum, Sir!"
	else:
		var format_string = "Weapons at %s, Sir!"
		slider.tooltip_text = format_string % slider.value


func _on_v_slider_value_changed(value = 50):
	var slider : VSlider = $VSlider
	if value == slider.max_value:
		slider.tooltip_text = "Shields at full capacity, Sir!"
	if value == slider.min_value:
		slider.tooltip_text = "Shields are failing, Sir!"
	else:
		var format_string = "Shields at %s, Sir!"
		slider.tooltip_text = format_string % slider.value

