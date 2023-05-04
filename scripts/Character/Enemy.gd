extends Character
class_name Enemy

enum PatrolType {
	Sequence,
	RandomTarget
}

@onready var fsm: AIStateMachine = $StateMachine
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_sensor: VisionSensor = $VisionSensor
@onready var sprite: Sprite2D = $Sprite2D

@export var patrol_type: PatrolType = PatrolType.Sequence
@export var patrol_wait: float = 3

@export var distance_to_shoot: float = 70

@export var pursue_look_angle: float = 45
@export var pursue_look_interval: float = 1.3
@export var pursue_find_time: float = 3
@export var pursue_wait_rotation_time: float = 3

@export var vision_cone_angle: float = 60
@export var vision_cone_range: float = 200
@export_flags_2d_physics var vision_layers

@export var point_value: float = 100
@onready var blood_effect_prefab = preload("res://scenes/effects/small_blood.tscn")
@onready var corpse_prefab = preload("res://scenes/effects/corpse.tscn")

var patrol_points: Array = []

# is dead once only
var is_dead: bool

func _ready():
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position

	fsm.init(self, weapon_manager.weapon, speed * 10)

func set_speed(new_speed: float):
	speed = new_speed
	fsm._movement_speed = speed * 10

func handle_hit(damager: Node2D, damages):
	health.hit(damages)
	if health.is_dead() and !is_dead:
		is_dead = true
		var spriteDeadEnemy = spawn(corpse_prefab, self.global_position)		
		GlobalSignals.enemy_died.emit(spriteDeadEnemy, point_value)
		#display le sprite au sol
		if damager is Projectile:
			var new_velocity: Vector2 = (damager as Projectile).direction
			new_velocity = new_velocity.normalized()
			spriteDeadEnemy.global_rotation = new_velocity.angle()
		queue_free()
	else:
		spawn(blood_effect_prefab, global_position)

func spawn(prefab: Resource, position: Vector2):
	var inst = prefab.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = position
	return inst
