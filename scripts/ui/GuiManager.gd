extends CanvasLayer
class_name GuiManager

@onready var pause_manager : PauseManager = $PauseManager
@onready var weapon_shop_manager : WeaponShopManager = $WeaponShopManager
@onready var choose_weapon_manager : ChooseWeaponManager = $ChooseWeaponManager

@onready var health_ui_manager : HealthUiManager = $HealthUiManager
@onready var cursor_manager : CursorManager = $CursorManager

@onready var pop_up_health_manager = $PopUpHealthManager
@onready var pop_up_points_manager = $PopUpPointsManager
@onready var pop_up_interaction_manager = $PopUpInteractionManager
@onready var pop_up_power_up_manager = $PopUpPowerUpManager
@onready var marker_interaction_manager = $MarkerInteractionManager

@onready var panel_points_manager = $PanelPointsManager
@onready var panel_power_ups_manager = $PanelPowerUpsManager
@onready var panel_kills_manager = $PanelKillsManager
@onready var panel_timer_manager = $PanelTimerManager
@onready var weapon_panel_manager = $WeaponPanelManager

@onready var minimap_manager = $MinimapManager
@onready var recap_level_manager = $RecapLevelManager
@onready var game_over_manager = $GameOverManager

var player_ref : Player


func init(player: Player):
	player_ref = player


func generate_ui():
	cursor_manager.player = player_ref
	
	health_ui_manager.set_active(true)
	marker_interaction_manager.set_active(true)
	cursor_manager.set_active(true)
	game_over_manager.set_active(false)
	minimap_manager.set_active(true)
	pause_manager.set_active(false)
	recap_level_manager.set_active(false)
	weapon_shop_manager.set_active(false)
	choose_weapon_manager.set_active(true)


func set_active_gui_panels(state: bool):
	# remove this panel
	panel_points_manager.panel.visible = false
	# !remove this panel
	
	panel_kills_manager.panel.visible = state
	panel_timer_manager.panel.visible = state
	panel_power_ups_manager.panel.visible = state
	weapon_panel_manager.set_active_panels(state)
	minimap_manager.set_active(state)
	#marker_interaction_manager.set_active(state)
	#health_ui_manager.set_active(state)
