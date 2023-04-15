extends Node2D
class_name Weapon

@export var shooter_actor : Node

var weapon_name : String = ""
var special_power_unlocked : bool = false
var level : int = 0

var points_to_unlock_power : int = 200
var current_points_charge_power : int = 0
var can_use_power : bool = false

var projectile : PackedScene
var bullet_speed : int = 4
var bullet_damages : int = 6
var bullet_size : float = 0.5
var bullet_impact_force : float = 2

var loader_capacity : int = 6

var enable : bool = true
#changer ces deux pareamètre par fréquence & amplitude (3 balles (fréqeunce) en 1s(amplitude))
var number_of_balls_by_burt : int = 1
var frequence_of_burt : float = 0.1 #time between balls of burts
var precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
var precision : float = 0 # the more it's close 0 the more it's precise
var recoil_force : float = 2 # the more it's close 0 the more it's precise

@onready var fire_position = $FirePosition
@onready var fire_direction = $FireDirection
@onready var attack_cooldown = $AttackCoolDown
@onready var reload_cooldown = $ReloadCoolDown
@onready var animation = $Animation
@onready var sprite = $Sprite2D
@onready var side_sprite = $SideSprite2D

func _ready():
	if get_parent() != null:
		shooter_actor = get_parent().get_parent()
	randomize()

func shoot():
	if !enable:
		return
	if attack_cooldown.is_stopped() and Projectile != null:
		attack_cooldown.start()
		
		for n in number_of_balls_by_burt:
			if n != 0:
				await get_tree().create_timer(frequence_of_burt).timeout
			
			#right method ?
			#set_projectile_scene_variables()
			var projectile_instance : Projectile = projectile.instantiate()
			var direction = fire_direction.global_position - fire_position.global_position
			
			direction += Vector2(_random_range(precision_angle), 0)#random direction (x), same distance (y)
			emit_signals(shooter_actor, projectile_instance, direction)
			recoil_shooter(direction)
			
			animation.play("muzzle_flash")

func recoil_shooter(direction: Vector2):
	if shooter_actor == null:
		return
	if shooter_actor is Character:
		shooter_actor.apply_force(shooter_actor, -direction, recoil_force)

#return a random float between x and y
func _random_range(angle: Vector2) -> float:
	var range : float = 0
	if randf()>0.5: #1 out of 2 chances
		range = randf()*angle.x
	else:
		range = randf()*angle.y
	range *= precision
	return range

func emit_signals(actor: Node2D, projectile_instance: Projectile, direction: Vector2):
	if actor is Player:
		GlobalSignals.player_fired.emit()
	if projectile_instance is Grenade:
		var landing_position : Vector2 = get_global_mouse_position()
		GlobalSignals.projectile_launched_spawn.emit(null, projectile_instance, fire_position.global_position, direction, landing_position)
	if projectile_instance is Bullet:
		GlobalSignals.projectile_fired_spawn.emit(null, projectile_instance, fire_position.global_position, direction)

func set_projectile_scene_variables():
	projectile.set("speed", bullet_speed)
	projectile.set("damages", bullet_damages)
	projectile.set("size", bullet_size)
	projectile.set("impact_force", bullet_impact_force)

func add_charge_power_points(points: int):
	current_points_charge_power += points
	if current_points_charge_power >= points_to_unlock_power:
		can_use_power = true
		#print("Can use special Power !")

