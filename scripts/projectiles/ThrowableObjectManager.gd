extends Node2D
class_name ThrowableObjectManager

var throwing_actor : Node

var object_name : String = ''

var throwing_sound : AudioStream
var sound_intensity : float = 1

var projectile_scene : PackedScene
var _current_nb_projectiles : int = 0
var ammo_size : int = 0
var precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
var precision : float = 0 # the more it's close 0 the more it's precise
var projectile_size : float = 0.5
var projectile_speed : int = 4
var projectile_damages : int = 20
var projectile_impact_force : float = 2
var projectile_should_bounce : bool = false
var projectile_max_distance : float = 200

#var projectile_impact_radius : float = 50
#...

# Variables de la classe Grenade :
#@export var radius_pixels_impact_area : float = 100
#@export var max_launch_distance : float = 400
#@export var landing_precision : int = 1

@onready var throwing_cooldown = $ThrowCoolDown
@onready var side_sprite = $SideSprite2D
@onready var throw_position = $ThrowPosition
@onready var throw_direction = $ThrowDirection


func _ready():
	if get_parent() != null:
		throwing_actor = get_parent().get_parent()
	randomize()


func throw():
	var has_throw : bool = false
	if throwing_cooldown.is_stopped()  and _current_nb_projectiles > 0:
		throwing_cooldown.start()
		
		_current_nb_projectiles -= 1
		
		var direction = throw_direction.global_position - throw_position.global_position
		has_throw = instantiate_projectile(direction)
		
		if has_throw:
			GlobalSignals.play_sound.emit(throwing_sound, 0, 1, global_position)


func instantiate_projectile(direction: Vector2) -> bool:
	var projectile_instance = projectile_scene.instantiate()
	set_projectile_variables(projectile_instance)
	direction += Vector2(_random_range(precision_angle), 0)#random direction (x), same distance (y)
	emit_signals(projectile_instance, direction)
	return true


func set_projectile_variables(projectile: Projectile):
	projectile.speed = projectile_speed
	projectile.damages = projectile_damages
	projectile.scale *= projectile_size
	projectile.impact_force = projectile_impact_force
	projectile.should_bounce = projectile_should_bounce
	#projectile_max_distance : float


func emit_signals(projectile_instance: Projectile, direction: Vector2):
	
	if throwing_actor is Player:
		GlobalSignals.player_throwed_object.emit()
	
	if projectile_instance is CatchingCable:
		GlobalSignals.catching_cable_spawned.emit(throwing_actor, projectile_instance, throw_position.global_position, direction, 2)
	elif projectile_instance is Grenade:
		var landing_position : Vector2 = get_global_mouse_position()
		GlobalSignals.projectile_launched_spawn.emit(throwing_actor, projectile_instance, throw_position.global_position, direction, landing_position)
	elif projectile_instance is Bullet:
		GlobalSignals.projectile_fired_spawn.emit(throwing_actor, projectile_instance, throw_position.global_position, direction)
	elif projectile_instance is Projectile:
		GlobalSignals.projectile_fired_spawn.emit(throwing_actor, projectile_instance, throw_position.global_position, direction)


#return a random float between x and y
func _random_range(angle: Vector2) -> float:
	var range : float = 0
	if randf()>0.5: #1 out of 2 chances
		range = randf()*angle.x
	else:
		range = randf()*angle.y
	range *= precision
	return range
