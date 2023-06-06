extends Character
class_name Enemy

enum PatrolType {
	Sequence,
	RandomTarget
}

@onready var fsm: AIStateMachine = $StateMachine
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_sensor: VisionSensor = $VisionSensor
@onready var hearing_sensor: HearingSensor = $HearingSensor
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine := $StateMachine as AIStateMachine

@export var patrol_type: PatrolType = PatrolType.Sequence
@export var patrol_wait: float = 3

@export var distance_to_shoot: float = 70

@export var pursue_look_angle: float = 45
@export var pursue_look_interval: float = 1.3
@export var pursue_find_time: float = 3
@export var pursue_move_distance: float = 500
@export var pursue_wait_before_look_around: float = 3

@export var vision_cone_angle: float = 60
@export var vision_cone_range: float = 200
@export_flags_2d_physics var vision_layers

@export var hearing_range: float = 20

@export var point_value: float = 100

var patrol_points: Array = []


func _ready():
	if weapon_manager == null:
		return
	weapon_manager.weapon.projectile_damages = weapon_manager.projectile_damages + GlobalVariables.level * 1.75 
	fsm.init(self, weapon_manager.weapon, speed * 10)
	set_weapon_position(self)
	set_weapon_animation(self)


func manage_animation():
	var move_direction := global_transform.x.normalized()
	
	if velocity == Vector2.ZERO:
		legs_animation.stop()
	else:
		legs_animation.play("running_enemy")
	legs_sprite.global_rotation = move_direction.angle()

func _physics_process(delta):
	if action_disabled:
		return
	manage_animation()


func set_speed(new_speed: float):
	speed = new_speed
	fsm._movement_speed = speed * 10


func handle_hit(damager: Node2D, damages):
	health.hit(damages)
	#go to player if he shooting us
	#todo: projectile_owner seems to be null on projectile
	#find a way to know the damager owner
	state_machine.transition_to(state_machine.FOLLOW_TARGET, {
		target = get_tree().current_scene.find_child("Player")
	})
	if health.is_dead() and !is_dead:
		is_dead = true
		var corpse_inst = instanciate_corpse(self.global_position, get_tree().current_scene, damager)
		GlobalSignals.enemy_died.emit(corpse_inst, point_value)
		queue_free()
	else:
		instanciate_blood_effect(self.global_position, get_tree().current_scene, damager)
