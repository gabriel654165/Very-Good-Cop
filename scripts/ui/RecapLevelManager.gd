extends Node2D
class_name RecapLevelManager

@export var active : bool = false
@export var aim_blur_intensity : float = 0.5
@export var time_to_blur : float = 0.5
@export var recap_level_gui : Control
@export var color_rect : Node
@export var level_value_label : Node
@export var label_time_spent : Label
@export var label_prompt_time_spent : Label
@export var label_rooms_cleared : Label
@export var label_prompt_rooms_cleared : Label
@export var label_kills_done : Label
@export var label_prompt_kills_done : Label
@export var label_combos_done : Label
@export var label_prompt_combos_done : Label
@export var label_power_up_taken : Label
@export var label_prompt_power_up_taken : Label
@export var label_money_to_earn : Label
@export var skip_button : Button
@export var continue_button : Button

var gui_manager : GuiManager = null
var current_blur_intensity : float = 0

var time_spent : float = 0
var rooms_cleared : int = 0
var kills_done : int = 0
var combos_done : int = 0
var power_up_taken : int = 0
var money_to_earn : float = 0

var add_time_value : float = 0.1
var add_rooms_value : float = 1
var add_kills_value : float = 1
var add_combos_value : float = 1
var add_power_ups_value : float = 1
var time_for_add_time_value : float = 0.00005
var time_for_add_rooms_value : float = 0.2
var time_for_add_kills_value : float = 0.2
var time_for_add_combos_value : float = 0.2
var time_for_add_power_ups_value : float = 0.2

var jobs_finished : bool = false
var jobs : Array[Callable] = []
var _counter_jobs: int = 0
var _total_jobs: int = 5


signal display_completed()


func job_completed():
	_counter_jobs += 1
	if _counter_jobs >= _total_jobs:
		display_completed.emit()


func _ready():
	gui_manager = get_parent() as GuiManager
	display_completed.connect(self.display_finished_labels)
	
	var job_1 = func():
		change_visibility_prompts(label_prompt_time_spent)
		await add_value_over_time(time_spent, add_time_value, time_for_add_time_value, label_time_spent)
		job_completed()
		change_visibility_prompts()
	var job_2 = func():
		change_visibility_prompts(label_prompt_rooms_cleared)
		await add_value_over_time(rooms_cleared, add_rooms_value, time_for_add_rooms_value, label_rooms_cleared)
		job_completed()
		change_visibility_prompts()
	var job_3 = func():
		change_visibility_prompts(label_prompt_kills_done)
		await add_value_over_time(kills_done, add_kills_value, time_for_add_kills_value, label_kills_done)
		job_completed()
		change_visibility_prompts()
	var job_4 = func():
		return
		change_visibility_prompts(label_prompt_combos_done)
		await add_value_over_time(combos_done, add_combos_value, time_for_add_combos_value, label_combos_done)
		job_completed()
		change_visibility_prompts()
	var job_5 = func():
		change_visibility_prompts(label_prompt_power_up_taken)
		await add_value_over_time(power_up_taken, add_power_ups_value, time_for_add_power_ups_value, label_power_up_taken)
		job_completed()
		change_visibility_prompts()
	
	jobs.append_array([job_1, job_2, job_3, job_4, job_5])
	_total_jobs = jobs.size()


func set_active(state: bool):
	if recap_level_gui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()


func _process(delta):
	if (active and current_blur_intensity < aim_blur_intensity) or (!active and current_blur_intensity > 0):
		color_rect.get_material().set_shader_parameter("intensity", current_blur_intensity)


func number_to_string(ref_value, current_value) -> String:
	if ref_value is float:
		return str("%2.2f" % [current_value])
	return str(current_value)


func add_value_over_time(aim_value, add_value, time_for_add_value: float, label: Label) -> bool:
	var current_value = 0

	if jobs_finished:
			return true
	while current_value < aim_value:
		current_value += add_value
		label.text = number_to_string(aim_value, current_value)
		await get_tree().create_timer(time_for_add_value).timeout
		if jobs_finished:
			return true
	
	label.text = number_to_string(aim_value, aim_value)
	return true


func change_visibility_prompts(visible_label: Label = null):
	label_prompt_time_spent.visible = false
	label_prompt_rooms_cleared.visible = false
	label_prompt_kills_done.visible = false
	label_prompt_combos_done.visible = false
	label_prompt_power_up_taken.visible = false
	if visible_label != null:
		visible_label.visible = true


func display_finished_labels():
	if jobs_finished:
		return
	jobs_finished = true
	skip_button.visible = false
	continue_button.visible = true
	label_time_spent.text = number_to_string(time_spent, time_spent)
	label_rooms_cleared.text = number_to_string(rooms_cleared, rooms_cleared)
	label_kills_done.text = number_to_string(kills_done, kills_done)
	label_combos_done.text = number_to_string(combos_done, combos_done)
	label_power_up_taken.text = number_to_string(power_up_taken, power_up_taken)
	change_visibility_prompts()


func set_level_variables():
	time_spent = gui_manager.panel_timer_manager.time
	rooms_cleared = 12
	kills_done = gui_manager.panel_kills_manager.current_kills
	combos_done = 5
	power_up_taken = gui_manager.panel_power_ups_manager.current_power_ups_taken


func calculate_money(time_spent: float, rooms_cleared: int, kills_done: int, combos_done: int, power_up_taken: int):
	
	#Calculer le temps moyen de chaques salles
	# -> nb d'enemy + difficultée * temps moyen
	
	#Additionner le temps de chaques salles
	
	#Money par kills
	
	#Money par room clear
	
	#Money par power_up taken
	
	pass


func generate_ui():
	set_level_variables()
	level_value_label.text = str(GlobalVariables.level)
	gui_manager.panel_timer_manager.stop_timer()
	recap_level_gui.visible = true
	GlobalFunctions.disable_all_game_objects(true)
	gui_manager.cursor_manager.cursor.active_mode_ui()
	gui_manager.set_active_gui_panels(false)
	gui_manager.pause_manager.disable_pause = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "current_blur_intensity", aim_blur_intensity, time_to_blur)
	for job in jobs:
		await job.call()
	
	#await load_money_earned()
	#money_to_earn : float = 0


func unload_ui():
	recap_level_gui.visible = false
	GlobalFunctions.disable_all_game_objects(false)


# Buttons signals
func _on_continue_button_pressed():
	unload_ui()
	gui_manager.weapon_shop_manager.set_active(true)


func _on_skip_button_pressed():
	display_completed.emit()
