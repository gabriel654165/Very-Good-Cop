extends Interaction

@export var time_to_complete : float = 2
@export var total_nb_click : int = 10
@export var key_code : Key = KEY_NONE
@onready var timer = $Timer as Timer

var started_clicking : bool = false
var current_nb_click : int = 0

func _ready():
	timer.wait_time = time_to_complete

func _process(delta):
	if !is_active || is_triggered:
		return
	if current_nb_click >= total_nb_click:
		#print("interaction : spam click = TRUE")
		is_triggered = true

func _input(event):
	#if !is_active:
	if !is_active || is_triggered:
		return
	if event is InputEventKey and event.keycode == key_code and event.pressed:
		#print(current_nb_click)
		current_nb_click += 1
		if !started_clicking:
			started_clicking = true
			timer.start()

func set_active(new_state: bool):
	is_active = new_state
	if !is_active:
		reset()

func reset():
	started_clicking = false
	current_nb_click = 0
	timer.wait_time = time_to_complete
	timer.stop()

func _on_timer_timeout():
	if !is_triggered:
		reset()
