extends AIState
class_name Patrol

var current_point: Vector2
var wait_timer = Timer.new()

enum PatrolType {
	Sequence,
	RandomTarget
}

@export var patrol_type: PatrolType = PatrolType.Sequence
@onready var detection_zone: Area2D = $"../../DetectionZone"

var current_point_index: int = 0

func _ready():
	wait_timer.timeout.connect(_on_wait_point_timeout)
	wait_timer.wait_time = 3
	wait_timer.one_shot = true
	add_child(wait_timer)

func get_target():
	if state_machine._enemy.patrol_points.size() == 0:
		return
	
	
	
	if patrol_type == PatrolType.Sequence:
		current_point_index = (current_point_index + 1) % state_machine._enemy.patrol_points.size()
		current_point = state_machine._enemy.patrol_points[current_point_index]
	else:
		var random_pos = state_machine._enemy.patrol_points.pick_random()
		while state_machine._enemy.patrol_points.size() > 1 and current_point == random_pos:
			random_pos = state_machine._enemy.patrol_points.pick_random()
		current_point = random_pos
	set_movement_target(current_point)

func enter(_msg := {}) -> void:
	detection_zone.body_entered.connect(_on_detection_zone_body_entered)
	state_machine.navigation_agent.target_reached.connect(_on_target_reached)
	get_target()

func exit() -> void:
	detection_zone.body_entered.disconnect(_on_detection_zone_body_entered)
	state_machine.navigation_agent.target_reached.disconnect(_on_target_reached)

#signals 
func _on_detection_zone_body_entered(body: Node2D):
	if body.is_in_group("player"):
		state_machine.transition_to(state_machine.FOLLOW_TARGET, { target = body })

func _on_wait_point_timeout():
	get_target()

func _on_target_reached() -> void:
	if wait_timer.is_stopped():
		wait_timer.start()
