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

@export var distance_to_shoot: float = 110

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
	GlobalSignals.weapon_shoot.connect(self.handle_shoot)
	GlobalSignals.weapon_stab.connect(self.handle_stab)
	GlobalSignals.throwed_distance_weapon.connect(self.handle_throwed_distance_weapon)
	if weapon_manager == null:
		return
	weapon_manager.weapon.projectile_damages = weapon_manager.projectile_damages + GlobalVariables.level * 1.75 
	fsm.init(self, weapon_manager.weapon, speed * 10)
	set_weapon_position()
	set_body_animation()


func _physics_process(delta):
	if action_disabled:
		return
	manage_animation(global_transform.x.normalized())


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
