extends Character
class_name Enemy

@onready var fsm: StateMachine = $StateMachine
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var room_config: RoomConfig = $"../RoomConfig"
@onready var vision_sensor: VisionSensor = $VisionSensor

@export var distance_to_shoot: float = 70
@export var point_value: float = 100
@onready var blood_effect_prefab = preload("res://scenes/effects/small_blood.tscn")
@onready var corpse_prefab = preload("res://scenes/effects/corpse.tscn")

var patrol_points: Array[Vector2] = []

func _ready():
	patrol_points = room_config.patrol_points
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position
	fsm.init(self, weapon_manager.weapon)

func handle_hit(damager: Node2D, damages):
	health.hit(damages)
	if health.is_dead():
		GlobalSignals.enemy_died.emit(global_position, point_value)
		#blood_inst.rotation = global_position.angle_to_point(damager.global_position)
		if damager is Projectile:
			var corpse = spawn(corpse_prefab, global_position)
#			var new_velocity: Vector2 = global_position - damager.global_position
			var new_velocity: Vector2 = (damager as Projectile).direction
			new_velocity = new_velocity.normalized()
			corpse.global_rotation = new_velocity.angle()
		
		queue_free()
	else:
		spawn(blood_effect_prefab, global_position)

func spawn(prefab: Resource, position: Vector2):
	var inst = prefab.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = position
	return inst
