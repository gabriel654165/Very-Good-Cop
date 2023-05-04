extends CanvasGroup
class_name PopUpText

@onready var life_timer = $LifeTimer
@onready var text_upper : Label = $TextUpper
@onready var text_under : Label = $TextUnder

var velocity_mov : Vector2 = Vector2(0, 0)
var velocity_scale : Vector2 = Vector2(60, 60)

var life_time : float = 2
var content : String
var current_offset := Vector2(0, 0)
var base_offset : Vector2 = Vector2(0, 0)
var world_target : Node2D = null

func _process(delta):
	current_offset += velocity_mov * delta
	
	if world_target != null:
		global_position = world_target.get_global_transform_with_canvas().origin + current_offset + base_offset
	else:
		global_position = get_viewport_rect().size / 2 + base_offset
	scale += velocity_scale * delta

func _on_life_timer_timeout():
	queue_free()

func set_content(new_content: String):
	content = new_content
	text_upper.text = content
	text_under.text = content

func set_life_time(new_life_time: float):
	life_time = new_life_time
	life_timer.wait_time = life_time
