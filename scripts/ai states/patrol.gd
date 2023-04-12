extends AIState

var current_point: Vector2

var wait_timer = Timer.new()

@onready var detection_zone: Area2D = $"../../DetectionZone"

func _ready():
	wait_timer.timeout.connect(_on_wait_point_timeout)
	wait_timer.wait_time = 3
	wait_timer.one_shot = true
	add_child(wait_timer)

func _on_wait_point_timeout():
	get_random_target()

func get_random_target():
	if room_config == null:
		return
	var random_pos = room_config.patrol_points.pick_random().position
	while current_point == random_pos:
		random_pos = room_config.patrol_points.pick_random().position
		continue
	current_point = random_pos
	set_movement_target(current_point)
	
func physics_update(delta: float) -> void:
	if state_machine.navigation_agent.is_navigation_finished():
		if wait_timer.is_stopped():
			wait_timer.start()
		return

	move()

func enter(_msg := {}) -> void:
	get_random_target()
	detection_zone.body_entered.connect(_on_detection_zone_body_entered)

func exit() -> void:
	detection_zone.body_entered.disconnect(_on_detection_zone_body_entered)	
	
	
#signals 
func _on_detection_zone_body_entered(body: Node2D):
	if body.is_in_group("player"):
		state_machine.transition_to(state_machine.FOLLOW_PLAYER, { target = body })
