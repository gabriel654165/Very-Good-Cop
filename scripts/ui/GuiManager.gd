extends CanvasLayer
class_name GuiManager

@onready var pause_manager : PauseManager = $PauseManager
@onready var weapon_shop_manager : WeaponShopManager = $WeaponShopManager
@onready var choose_weapon_manager : ChooseWeaponManager = $ChooseWeaponManager

@onready var health_ui_manager : HealthUiManager = $HealthUiManager
@onready var cursor_manager : CursorManager = $CursorManager

@onready var pop_up_health_manager = $PopUpHealthManager
@onready var pop_up_points_manager = $PopUpPointsManager

@onready var panel_points_manager = $PanelPointsManager
@onready var panel_kills_manager = $PanelKillsManager
@onready var panel_timer_manager = $PanelTimerManager
@onready var weapon_panel_manager = $WeaponPanelManager

@onready var minimap_manager = $MinimapManager
@onready var game_over_manager = $GameOverManager

var player_ref : Player

func generate_ui():
	cursor_manager.player = player_ref
	
	health_ui_manager.set_active(true)
	cursor_manager.set_active(true)
	game_over_manager.set_active(false)
	minimap_manager.set_active(true)
	game_over_manager.set_active(false)
	pause_manager.set_active(false)
	weapon_shop_manager.set_active(false)
	choose_weapon_manager.set_active(true)
	
	#health_ui_manager.set_active(false)
	#cursor_manager.set_active(true)
	#pause_manager.set_active(false)
	#weapon_shop_manager.set_active(false)
	#choose_weapon_manager.set_active(false)
	#game_over_manager.set_active(true)
	#minimap_manager.set_active(false)

func set_active_gui_panels(state: bool):
	panel_points_manager.panel.visible = state
	panel_kills_manager.panel.visible = state
	panel_timer_manager.panel.visible = state
	weapon_panel_manager.set_active_panels(state)
	minimap_manager.set_active(state)
