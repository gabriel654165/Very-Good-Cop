extends AIState
class_name FollowPlayer

var _target: Node2D = null;

var direction: Vector2
var find_timer = Timer.new()
var wait_rotation_timer = Timer.new()

func _ready():
	find_timer.timeout.connect(_on_pursuit_time_timeout)
	find_timer.wait_time = 3
	find_timer.one_shot = true
	add_child(find_timer)
	
	wait_rotation_timer.timeout.connect(_on_wait_point_timeout)
	wait_rotation_timer.wait_time = 3
	wait_rotation_timer.one_shot = true
	add_child(wait_rotation_timer)

func update(_delta: float) -> void:
	if _target != null:
		set_movement_target(_target.global_transform.origin)
		if state_machine._enemy.global_transform.origin.distance_to(_target.global_transform.origin) <= state_machine._enemy.distance_to_shoot + 40:
			state_machine.transition_to(state_machine.SHOOT, { target = _target })
	else:
		print("Target null")
		set_movement_target(state_machine._enemy.global_transform.origin + direction * 100)

func enter(_msg := {}) -> void:
	_target = _msg["target"]
	if !vision_sensor.lost_target.is_connected(_on_loose_target):
		vision_sensor.lost_target.connect(_on_loose_target)
	if !vision_sensor.lost_target.is_connected(_on_see_target):
		vision_sensor.lost_target.connect(_on_see_target)

func exit() -> void:
	vision_sensor.lost_target.disconnect(_on_loose_target)
	vision_sensor.lost_target.disconnect(_on_see_target)

#signals 
func _on_loose_target(target: DetectableTarget):
	print("Target Lost")
	direction = _target.global_transform.origin - state_machine._enemy.global_transform.origin
	direction = direction.normalized()
	set_movement_target(state_machine._enemy.global_transform.origin + direction * 200)	
	find_timer.start()
	_target = null

func _on_see_target(target: DetectableTarget):
	print("Target Regain")
	_target = target

func _on_pursuit_time_timeout():
	wait_rotation_timer.start()

func _on_wait_point_timeout():
	direction = Vector2()
	var tween = get_tree().create_tween()
	tween.set_parallel(false)
	tween.tween_property(state_machine._enemy.sprite, "rotation", 34.3, 1)
	tween.tween_interval(2)
	tween.tween_property(state_machine._enemy.sprite, "rotation", 0, 1)
	tween.tween_callback(func(): state_machine.transition_to(state_machine.PATROL))
	
