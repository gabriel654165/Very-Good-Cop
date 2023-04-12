extends AIState
class_name Patrol

var current_point: Vector2
var wait_timer = Timer.new()

@onready var detection_zone: Area2D = $"../../DetectionZone"

func _ready():
	wait_timer.timeout.connect(_on_wait_point_timeout)
	wait_timer.wait_time = 3
	wait_timer.one_shot = true
	add_child(wait_timer)

func get_random_target():
	if room_config == null:
		return

	var random_pos = room_config.patrol_points.pick_random()
	while current_point == random_pos:
		random_pos = room_config.patrol_points.pick_random()
		continue
	current_point = random_pos
	set_movement_target(current_point)

func enter(_msg := {}) -> void:
	detection_zone.body_entered.connect(_on_detection_zone_body_entered)
	state_machine.navigation_agent.target_reached.connect(_on_target_reached)
	get_random_target()	

func exit() -> void:
	detection_zone.body_entered.disconnect(_on_detection_zone_body_entered)
	state_machine.navigation_agent.target_reached.disconnect(_on_target_reached)	

#signals 
func _on_detection_zone_body_entered(body: Node2D):
	if body.is_in_group("player"):
		state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = body })

func _on_wait_point_timeout():
	get_random_target()

func _on_target_reached() -> void:
	if wait_timer.is_stopped():
		wait_timer.start()
