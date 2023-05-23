extends Node2D
class_name ChooseWeaponManager

@export var active : bool = false
@export var aim_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5

@export var pop_up_text_scene : PackedScene
@export var pop_up_contents : Array[String] = ["3", "2", "1", "Go !!!"]
@export var resume_pop_up_duration : float = 0.5
@export var resume_pop_up_scale := Vector2(5, 5)
@export var resume_pop_up_velocity_scale := Vector2(3, 3)

@export var choose_weapon_gui : Node = null
@export var base_panel : Node = null
@export var color_rect : Node = null

@export var distance_weapon_grid : Node = null
@export var melee_weapon_grid : Node = null

@export var choose_weapon_item_panel_scene : PackedScene

var gui_manager : GuiManager = null
var current_blur_intensity : float = 0
var pop_up_timer : Timer = null
var array_player_distance_weapon : Array[ChooseWeaponItemPanel] = []
var array_player_melee_weapon : Array[ChooseWeaponItemPanel] = []

func _ready():
	gui_manager = get_parent() as GuiManager
	array_player_distance_weapon = generate_item_list_by_save(GlobalVariables.all_distance_weapon_list, GlobalVariables.player_distance_weapon_list, distance_weapon_grid)
	array_player_melee_weapon = generate_item_list_by_save(GlobalVariables.all_melee_weapon_list, GlobalVariables.player_melee_weapon_list, melee_weapon_grid)
	update_selected_weapon()

func _process(delta):
	if (active and current_blur_intensity < aim_blur_intensity) or (!active and current_blur_intensity > 0):
		color_rect.get_material().set_shader_parameter("intensity", current_blur_intensity)

func set_active(state: bool):
	if choose_weapon_gui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()

func generate_ui():
	GlobalFunctions.disable_all_game_objects(true)
	choose_weapon_gui.visible = true
	base_panel.visible = true
	gui_manager.cursor_manager.cursor.active_mode_ui()
	gui_manager.set_active_gui_panels(false)
	gui_manager.pause_manager.disable_pause = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", aim_blur_intensity, time_to_blur)

func unload_ui():
	choose_weapon_gui.visible = false
	base_panel.visible = true
	color_rect.get_material().set_shader_parameter("intensity", 0)

func start_game():
	base_panel.visible = false
	gui_manager.cursor_manager.cursor.active_mode_idle_gui()
	gui_manager.set_active_gui_panels(true)
	gui_manager.pause_manager.disable_pause = false
	gui_manager.weapon_panel_manager.set_weapon_panel_variables()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", 0, time_to_blur)
	if await start_resume_animation():
		GlobalFunctions.disable_all_game_objects(false)
		gui_manager.panel_timer_manager.resume_timer()
		set_active(false)

func instanciate_pop_up_text(content: String, duration: float, velocity_scale: Vector2) -> Timer:
	var pop_up_text_instance = pop_up_text_scene.instantiate()
	add_child(pop_up_text_instance)
	
	pop_up_text_instance.world_target = null
	pop_up_text_instance.scale = resume_pop_up_scale
	pop_up_text_instance.set_life_time(duration)
	pop_up_text_instance.velocity_scale = velocity_scale
	pop_up_text_instance.set_content(content)
	pop_up_text_instance.life_timer.start()
	return pop_up_text_instance.life_timer

func start_resume_animation() -> bool:
	var index : int = 0
	for pop_up_content in pop_up_contents:
		#last pop up will stay twice longer
		if index == pop_up_contents.size() -1:
			pop_up_timer = instanciate_pop_up_text(pop_up_content, resume_pop_up_duration * 2, resume_pop_up_velocity_scale / 2)
		else:
			pop_up_timer = instanciate_pop_up_text(pop_up_content, resume_pop_up_duration, resume_pop_up_velocity_scale)
		await pop_up_timer.timeout
		if pop_up_timer == null:
			return false
		index += 1
	pop_up_timer = null
	return true

func generate_item_list_by_save(all_item_infos_list, player_item_list, parent) -> Array[ChooseWeaponItemPanel]:
	var item_ui_list : Array[ChooseWeaponItemPanel] = []
	var index : int = 0
	
	for item_infos in all_item_infos_list:
		if player_item_list[index].unlocked:
			var item_ui = choose_weapon_item_panel_scene.instantiate()
			item_ui.weapon_manager = self
			item_ui.item_global_index = index
			parent.add_child(item_ui)
			item_ui_list.push_front(item_ui)
			item_ui.set_item_name(item_infos.name)
			item_ui.item_texture.texture = item_infos.gui_texture
		index += 1
	return item_ui_list

func update_selected_weapon():
	for item in array_player_distance_weapon:
		if GlobalVariables.index_distance_weapon_selected != item.item_global_index:
			item.selected = false
			item.item_check_box.button_pressed = false
		else:
			item.selected = true
			item.item_check_box.button_pressed = true
	for item in array_player_melee_weapon:
		if GlobalVariables.index_melee_weapon_selected != item.item_global_index:
			item.selected = false
			item.item_check_box.button_pressed = false
		else:
			item.selected = true
			item.item_check_box.button_pressed = true

# Signals
func _on_start_button_pressed():
	GlobalSignals.assign_player_weapons.emit()
	start_game()

func _on_quit_button_pressed():
	get_tree().quit()
