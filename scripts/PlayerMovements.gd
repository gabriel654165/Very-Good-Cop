extends CharacterBody2D

enum PLAYER_STATE { IDLE, WALK }

signal player_fired_bullet(bullet, position, direction)

@export var player_speed : float = 100
@export var Bullet : PackedScene

@onready var fire_position = $FirePosition
@onready var fire_direction = $FireDirection
#@onready var animation_tree = $AnimationTree
#@onready var state_machine = animation_tree.get("paramter/playback")

var move_direction : Vector2 = Vector2.ZERO
var current_state : PLAYER_STATE = PLAYER_STATE.IDLE

func _physics_process(delta):
	var move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = move_direction * player_speed
	move_and_slide()
	
	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		shoot()
		
func shoot():
	var bullet_instance = Bullet.instantiate()
	var direction = fire_direction.global_position - fire_position.global_position
	emit_signal("player_fired_bullet", bullet_instance, fire_position.global_position, direction)
