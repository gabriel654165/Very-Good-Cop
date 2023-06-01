extends CanvasLayer
class_name GuiManager

@onready var pause_manager : PauseManager = $PauseManager

@onready var health_ui_manager : HealthUiManager = $HealthUiManager
@onready var cursor_manager : CursorManager = $CursorManager

@onready var pop_up_health_manager = $PopUpHealthManager
@onready var pop_up_points_manager = $PopUpPointsManager

@onready var panel_points_manager = $PanelPointsManager
@onready var panel_kills_manager = $PanelKillsManager
@onready var panel_timer_manager = $PanelTimerManager
@onready var weapon_panel_manager = $WeaponPanelManager

@onready var minimap_manager = $MinimapManager

func generate_ui():
	health_ui_manager.set_active(true)
	cursor_manager.set_active(true)
	minimap_manager.set_active(true)
