extends Node2D

enum ENEMY_STATE {
	PATERN,
	SPOTED
}
var _player : Player = null
var _weapon : Weapon = null
var _enemy : Enemy = null

signal state_changed(new_state)

@onready var detection_zone = $DetectionZone

@export var state : ENEMY_STATE = ENEMY_STATE.PATERN : set = _set_state, get = _get_state

func _process(delta):
	match state:
		ENEMY_STATE.PATERN:
			pass
		ENEMY_STATE.SPOTED:
			if _weapon != null && _player != null:
				_enemy.rotation = _enemy.global_position.direction_to(_player.global_position).angle()
				_weapon.shoot()
			else:
				print("Enemy spoted but enemy has no weapon")
		_:
			print("Enemy state not known")

func init(enemy: Enemy, new_weapon: Weapon):
	_enemy = enemy
	_weapon = new_weapon

func _set_state(new_state: ENEMY_STATE):
	if new_state == state:
		return
		
	state = new_state
	emit_signal("state_changed", new_state)

func _get_state():
	return state

#signals 
func _on_detection_zone_body_entered(body):
	if body.is_in_group("player"):
		_set_state(ENEMY_STATE.SPOTED)
		_player = body
	pass
