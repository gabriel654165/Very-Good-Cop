extends AIState
class_name KamikazDeath

@onready var _explosion_area: Area2D = $"../../ExplosionDamageArea"
@onready var _explosion_timer: Timer = $TimerBeforeExplode
@onready var explosion_vfx_prefab = preload("res://scenes/effects/explosion_vfx.tscn")

func enter(_msg := {}) -> void:
	_explosion_timer.wait_time = _msg['explode_time']
	state_machine.navigation_agent.set_process(false)
	state_machine.navigation_agent.set_physics_process(false)
	if _explosion_timer.is_stopped():
		_explosion_timer.start()
	
func exit() -> void:
	_explosion_timer.stop()

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
