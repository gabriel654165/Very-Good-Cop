extends Character
class_name Player

#enum PLAYER_STATE { IDLE, WALK }

@export var player_speed : float = 100
@export var recul_factor : float = 100

@onready var weapon = $Weapon
@onready var health: Health = $Health
#@onready var animation_tree = $AnimationTree
#@onready var state_machine = animation_tree.get("paramter/playback")

var move_direction : Vector2 = Vector2.ZERO
#var current_state : PLAYER_STATE = PLAYER_STATE.IDLE

func _physics_process(delta):
	var move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	velocity = (move_direction * recul_factor) * player_speed 
	if recul_factor != 1:
		recul_factor = 1
	move_and_slide()
	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		weapon.shoot()

func handle_hit(damages):
	recul_factor = -1
	health.hit(damages)
