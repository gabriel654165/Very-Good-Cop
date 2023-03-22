extends Character
class_name Player

@export var player_speed : float = 6

@onready var weapon = $Weapon
@onready var health: Health = $Health
#@onready var animation_tree = $AnimationTree
#@onready var state_machine = animation_tree.get("paramter/playback")

enum PLAYER_STATE { IDLE, WALK }
var move_direction : Vector2 = Vector2.ZERO
#var current_state : PLAYER_STATE = PLAYER_STATE.IDLE

func _physics_process(delta):
	var move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if self.force != Vector2.ZERO:
		velocity += self.force
		self.force = Vector2.ZERO
		
	if move_direction != Vector2.ZERO:
		velocity += move_direction * GlobalFunctions.get_speed(delta, player_speed) + self.force
	global_position += velocity
	move_and_slide()
	velocity = Vector2.ZERO
	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		weapon.shoot()

func handle_hit(damages):
	health.hit(damages)
