extends CanvasLayer
class_name GuiManager

@onready var health_ui_manager = $HealthUiManager
@onready var cursor_manager = $CursorManager

func generateUi():
	health_ui_manager.set_active(true)
	cursor_manager.set_active(true)
