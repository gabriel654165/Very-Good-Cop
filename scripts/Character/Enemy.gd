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
@onready var blood_effect_prefab = preload("res://scenes/effects/small_blood.tscn")
@onready var corpse_prefab = preload("res://scenes/effects/corpse.tscn")

var patrol_points: Array = []

# is dead once only
var is_dead: bool

func _ready():
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position

	weapon_manager.weapon.projectile_damages = weapon_manager.projectile_damages + GlobalVariables.level * 1.75 
	fsm.init(self, weapon_manager.weapon, speed * 10)

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
		var sprite_dead_enemy = GlobalFunctions.spawn(corpse_prefab, self.global_position)
		GlobalSignals.enemy_died.emit(sprite_dead_enemy, point_value)

		if damager is Projectile:
			var new_velocity: Vector2 = (damager as Projectile).direction
			new_velocity = new_velocity.normalized()
			sprite_dead_enemy.global_rotation = new_velocity.angle()
		queue_free()
	else:
		GlobalFunctions.spawn(blood_effect_prefab, global_position)
