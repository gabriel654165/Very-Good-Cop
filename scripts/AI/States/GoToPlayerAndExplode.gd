extends AIState
class_name GoToPlayerAndExplode

var _speed: float
var _target: Node2D
@onready var _explosion_area: Area2D = $"../../ExplosionDamageArea"
@onready var _explosion_timer: Timer = $TimerBeforeExplode
@onready var explosion_vfx_prefab = preload("res://scenes/effects/explosion_vfx.tscn")

var time_before_explode: float = 3

func enter(_msg := {}) -> void:
	_explosion_timer.wait_time = time_before_explode	
#	_speed = _msg["speed"]
	state_machine._movement_speed *= 3
	_target = get_tree().current_scene.find_child("Player")
	set_movement_target(_target.global_position)

	if not state_machine.navigation_agent.navigation_finished.is_connected(on_navigation_finished):
		state_machine.navigation_agent.navigation_finished.connect(on_navigation_finished)

func update(_delta: float) -> void:
	if state_machine._enemy.global_transform.origin.distance_to(_target.global_transform.origin) <= 35:
		on_navigation_finished()
	set_movement_target(_target.global_position)
	
func exit() -> void:
	_explosion_timer.stop()

func on_navigation_finished():
	state_machine.navigation_agent.set_process(false)
	state_machine.navigation_agent.set_physics_process(false)
	if _explosion_timer.is_stopped():
		_explosion_timer.start()

func _on_timer_before_explode_timeout():
	explode()

func explode():
	var instance = GlobalFunctions.spawn_and_destroy(explosion_vfx_prefab, state_machine._enemy.global_position, 2)
	instance.restart()
	instance.emitting = true

	if _explosion_area.has_overlapping_bodies():
		for body in _explosion_area.get_overlapping_bodies():
			if body == state_machine._enemy:
				continue
			if body.has_method("handle_hit"):
				body.handle_hit(state_machine._enemy, 35)
	state_machine._enemy.handle_hit(state_machine._enemy, 999)



