extends Interaction
class_name EndLevelInteraction

var gui_manager : GuiManager = null

func trigger(actor: Node):
	gui_manager = GlobalFunctions.find_object_on_condition(func(elem: Node): return elem is GuiManager, get_tree().root)
	if gui_manager == null:
		return
	
	gui_manager.recap_level_manager.set_active(true)
	set_active(false)
