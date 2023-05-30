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
@export var blood_effect_scene : PackedScene
@export var corpse_scene : PackedScene

var patrol_points: Array = []

# is dead once only
var is_dead: bool

func _ready():
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position

	weapon_manager.weapon.bullet_damages = weapon_manager.bullet_damages + GlobalVariables.level * 1.75 
	fsm.init(self, weapon_manager.weapon, speed * 10)

func _process(delta):
	if action_disabled:
		return

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
		var sprite_dead_enemy = instanciate_corpse(self.global_position, get_tree().current_scene, damager)
		GlobalSignals.enemy_died.emit(sprite_dead_enemy, point_value)
		queue_free()
	else:
		instanciate_blood_effect(self.global_position, get_tree().current_scene, damager)

func instanciate_corpse(position: Vector2, parent: Node, damager: Node2D) -> Node:
	var inst = corpse_scene.instantiate()
	parent.add_child(inst)
	inst.global_position = position
	if damager is Projectile:
		var new_velocity: Vector2 = (damager as Projectile).direction
		new_velocity = new_velocity.normalized()
		inst.global_rotation = new_velocity.angle()
	return inst

func instanciate_blood_effect(position: Vector2, parent: Node, damager: Node2D):
	var inst = blood_effect_scene.instantiate()
	parent.add_child(inst)
	if damager is Projectile:
		var new_velocity : Vector2 = damager.direction.normalized()
		inst.get_node("SubViewportContainer/PixelizedSubViewport/SquareBloodParticles").set_rotation(new_velocity.angle())
		inst.get_node("SubViewportContainer/PixelizedSubViewport/CircleBloodParticles").set_rotation(new_velocity.angle())
	inst.global_position = position - inst.size / 2
