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
@export var label_power_up_taken : Label
@export var label_prompt_power_up_taken : Label
@export var label_money_to_earn : Label
@export var skip_button : Button
@export var continue_button : Button

var gui_manager : GuiManager = null
var level_difficulty_inst : LevelDifficulty = null
var current_blur_intensity : float = 0

var time_spent : float = 0
var current_time_spent : float = 0
var rooms_cleared : int = 0
var current_rooms_cleared : int = 0
var kills_done : int = 0
var current_kills_done : int = 0
var power_up_taken : int = 0
var current_power_up_taken : int = 0
var money_to_earn : float = 0
var current_money_to_earn : float = 0

var add_time_value : float = 0.1
var add_rooms_value : float = 1
var add_kills_value : float = 1
var add_power_ups_value : float = 1
var add_money_value : float = 1
var time_for_add_time_value : float = 0.00005
var time_for_add_rooms_value : float = 0.1
var time_for_add_kills_value : float = 0.1
var time_for_add_power_ups_value : float = 0.1
var time_for_add_money_value : float = 0.0005

var jobs_finished : bool = false
var jobs : Array[Callable] = []
var _counter_jobs: int = 0
var _total_jobs: int = 5

var finished_counting_sound : AudioStreamMP3

signal display_completed()


func _ready():
	gui_manager = get_parent() as GuiManager
	display_completed.connect(self.display_finished_labels)
	
	finished_counting_sound = AudioStreamMP3.new()
	(finished_counting_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes("res://assets/Sounds/ui/recap_points/cash_register.mp3")
	
	var job_1 = func():
		change_visibility_prompts(label_prompt_time_spent)
		await add_value_over_time(current_time_spent, time_spent, add_time_value, time_for_add_time_value, label_time_spent, 2)
		job_completed()
		change_visibility_prompts()
	var job_2 = func():
		change_visibility_prompts(label_prompt_rooms_cleared)
		await add_value_over_time(current_rooms_cleared, rooms_cleared, add_rooms_value, time_for_add_rooms_value, label_rooms_cleared)
		job_completed()
		change_visibility_prompts()
	var job_3 = func():
		change_visibility_prompts(label_prompt_kills_done)
		await add_value_over_time(current_kills_done, kills_done, add_kills_value, time_for_add_kills_value, label_kills_done)
		job_completed()
		change_visibility_prompts()
	var job_4 = func():
		change_visibility_prompts(label_prompt_power_up_taken)
		await add_value_over_time(current_power_up_taken, power_up_taken, add_power_ups_value, time_for_add_power_ups_value, label_power_up_taken)
		job_completed()
		change_visibility_prompts()
	var job_5 = func():
		await add_value_over_time(current_money_to_earn, money_to_earn, add_money_value, time_for_add_money_value, label_money_to_earn, 0)
		job_completed()
	
	jobs.append_array([job_1, job_2, job_3, job_4, job_5])
	_total_jobs = jobs.size()


func job_completed():
	_counter_jobs += 1
	if _counter_jobs >= _total_jobs:
		display_completed.emit()


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


func number_to_string(ref_value, current_value, decimal_numbers: int = 2) -> String:
	if ref_value is float:
		return str(("%2."+str(decimal_numbers)+"f") % [current_value])
	return str(current_value)


func add_value_over_time(current_value, aim_value, add_value, time_for_add_value: float, label: Label, decimal_numbers: int = 2) -> bool:
	if jobs_finished:
			return true
	while current_value < aim_value:
		current_value += add_value
		label.text = number_to_string(aim_value, current_value, decimal_numbers)
		calculate_money(current_time_spent, current_rooms_cleared, current_kills_done, current_power_up_taken)
		await get_tree().create_timer(time_for_add_value).timeout
		if jobs_finished:
			return true
	
	label.text = number_to_string(aim_value, aim_value)
	return true


func change_visibility_prompts(visible_label: Label = null):
	label_prompt_time_spent.visible = false
	label_prompt_rooms_cleared.visible = false
	label_prompt_kills_done.visible = false
	label_prompt_power_up_taken.visible = false
	if visible_label != null:
		visible_label.visible = true


func display_finished_labels():
	if jobs_finished:
		return
	GlobalSignals.play_sound.emit(finished_counting_sound, 2, 1, global_position)
	jobs_finished = true
	skip_button.visible = false
	continue_button.visible = true
	label_time_spent.text = number_to_string(time_spent, time_spent, 2)
	label_rooms_cleared.text = number_to_string(rooms_cleared, rooms_cleared)
	label_kills_done.text = number_to_string(kills_done, kills_done)
	label_power_up_taken.text = number_to_string(power_up_taken, power_up_taken)
	label_money_to_earn.text = number_to_string(money_to_earn, money_to_earn, 0)
	change_visibility_prompts()


func set_level_variables():
	time_spent = gui_manager.panel_timer_manager.time
	rooms_cleared = 0
	kills_done = gui_manager.panel_kills_manager.current_kills
	power_up_taken = gui_manager.panel_power_ups_manager.current_power_ups_taken
	money_to_earn = calculate_money(time_spent, rooms_cleared, kills_done, power_up_taken)


func calculate_money(static_time_spent: float, static_rooms_cleared: int, static_kills_done: int, static_power_up_taken: int):
	var time_prct_ratio = (level_difficulty_inst.average_level_time - static_time_spent) / static_time_spent * 100
	var static_money_to_earn = level_difficulty_inst.calculate_money_bonus(static_rooms_cleared, static_kills_done, static_power_up_taken)
	
	if time_prct_ratio < 0:
		static_money_to_earn = static_money_to_earn - (time_prct_ratio/100*static_money_to_earn)
	elif time_prct_ratio > 0:
		static_money_to_earn = static_money_to_earn + ((time_prct_ratio * 2)/100*static_money_to_earn)
	
	return static_money_to_earn


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


func unload_ui():
	recap_level_gui.visible = false
	GlobalFunctions.disable_all_game_objects(false)


# Buttons signals
func _on_continue_button_pressed():
	GlobalVariables.money += money_to_earn
	unload_ui()
	gui_manager.weapon_shop_manager.set_active(true)


func _on_skip_button_pressed():
	display_completed.emit()
