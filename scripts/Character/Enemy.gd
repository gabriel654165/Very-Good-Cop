extends Character
class_name Enemy

@onready var fsm: StateMachine = $StateMachine
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var vision_sensor: VisionSensor = $VisionSensor
@onready var spriteDead: Sprite2D = $SpriteDead

@export var distance_to_shoot: float = 70
@export var point_value: float = 100
@onready var blood_effect_prefab = preload("res://scenes/effects/blood.tscn")

var patrol_points: Array = []
var room_config : RoomConfig = null

func _ready():
	weapon_manager = get_node("WeaponManager")
	weapon_manager.weapon.global_position = weapon_position.global_position

	fsm.init(self, weapon_manager.weapon)

func handle_hit(damager: Node2D, damages):
	health.hit(damages)
	if health.is_dead():
		var spriteDeadEnemy = spawnSprite(self.global_position, spriteDead)
		GlobalSignals.enemy_died.emit(spriteDeadEnemy, point_value)
		#display le sprite au sol
		var blood_inst = blood_effect_prefab.instantiate()
		get_tree().current_scene.add_child(blood_inst)
		blood_inst.global_position = global_position
		#blood_inst.rotation = global_position.angle_to_point(damager.global_position)
		if damager is Projectile:
			#var new_velocity: Vector2 = global_position - damager.global_position
			var new_velocity: Vector2 = (damager as Projectile).direction
			new_velocity = new_velocity.normalized()
			blood_inst.global_rotation = new_velocity.angle()
		
		queue_free()
