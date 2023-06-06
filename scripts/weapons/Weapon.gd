extends Node2D
class_name Weapon

@export var shot_shell_particle_scene : PackedScene

var shooter_actor : Node
var shooting_sound : AudioStream
var reloading_sound : AudioStream


var weapon_name : String = ''

var sound_intensity : float = 1

var points_to_use_special_power : int = 2
var current_points_to_use_special_power : int = 0
var can_use_power : bool = false
var power_activated : bool = false

var projectile_scene : PackedScene
var projectile_speed : int = 4
var projectile_damages : int = 6
var projectile_size : float = 0.5
var projectile_impact_force : float = 2
var projectile_piercing_force : int = 0
var projectile_should_bounce : bool = false
var projectile_should_pierce_walls : bool = false

var projectile_should_frag : bool = false
var frag_projectile_precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
var frag_projectile_precision : float = 1
var number_of_frag_projectile : int = 3

var ammo_size : int = 6
var _current_loader_bullets_number : int = 0
var ammo_reloading_time : float = 1
var shot_shell_texture : Texture2D

var enable : bool = true
#changer ces deux pareamètre par fréquence & amplitude (3 balles (fréqeunce) en 1s(amplitude))
var balls_by_burt : int = 1
var frequence_of_burt : float = 0
var precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
var precision : float = 0 # the more it's close 0 the more it's precise
var recoil_force : float = 2
var auto_lock_target : bool = false

var special_power : SpecialPower

@onready var fire_position = $FirePosition
@onready var fire_direction = $FireDirection
@onready var shooting_cooldown = $AttackCoolDown
@onready var reload_cooldown = $ReloadCoolDown
@onready var animation = $Animation
@onready var sprite = $Sprite2D
@onready var side_sprite = $SideSprite2D


func _ready():
	if get_parent() != null:
		shooter_actor = get_parent().get_parent().get_parent()
	randomize()
	
	# TODO: To remove @gabriel
	shooting_sound = AudioStreamMP3.new()
	(shooting_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes("res://assets/Sounds/5.56.mp3")

	reloading_sound = AudioStreamMP3.new()
	(reloading_sound as AudioStreamMP3).data = FileAccess.get_file_as_bytes("res://assets/Sounds/reload.mp3")

func shoot():
	if !enable:
		return
	
	var has_shoot : bool = false
	if (shooting_cooldown.is_stopped() or should_disable_cooldown()) and Projectile != null and _current_loader_bullets_number >= 0:
		shooting_cooldown.start()
		for n in balls_by_burt:
			
			_current_loader_bullets_number -= 1
			if _current_loader_bullets_number == 0:
				reload_magazine()
			if _current_loader_bullets_number < 0:
				return
			
			if n != 0:
				await get_tree().create_timer(frequence_of_burt).timeout
			
			var direction = fire_direction.global_position - fire_position.global_position
			has_shoot = instantiate_projectile(direction)
			instantiate_shot_shell()
			recoil_shooter(direction)
			#animation.play("muzzle_flash")
			
		if has_shoot:
			GlobalSignals.play_sound.emit(shooting_sound, 0, 1, global_position)


func instantiate_projectile(direction: Vector2) -> bool:
	var projectile_instance = projectile_scene.instantiate()
	set_projectile_variables(projectile_instance)
	direction += Vector2(_random_range(precision_angle), 0)#random direction (x), same distance (y)
	emit_signals(shooter_actor, projectile_instance, direction)
	return true

func instantiate_shot_shell():
	if shot_shell_texture == null:
		return
	var shot_shell_inst = shot_shell_particle_scene.instantiate()
	get_tree().current_scene.add_child(shot_shell_inst)
	shot_shell_inst.global_position = self.global_position
	shot_shell_inst.global_rotation = self.global_rotation
	shot_shell_inst.set_texture(shot_shell_texture)
	shot_shell_inst.emitting = true


func should_disable_cooldown() -> bool:
	if special_power == null:
		return false
	if "is_shooting" in special_power:
		return special_power.is_shooting
	return false;

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
	
	GlobalSignals.weapon_shoot.emit(actor)
	
	if actor is Player:
		GlobalSignals.player_fired.emit()
		GlobalSignals.sound_emitted.emit(actor, actor.global_position, sound_intensity)
	
	if projectile_instance is CatchingCable:
		GlobalSignals.catching_cable_spawned.emit(null, projectile_instance, fire_position.global_position, direction, 2)
	elif projectile_instance is Grenade:
		var landing_position : Vector2 = get_global_mouse_position()
		GlobalSignals.projectile_launched_spawn.emit(null, projectile_instance, fire_position.global_position, direction, landing_position)
	elif projectile_instance is Bullet:
		GlobalSignals.projectile_fired_spawn.emit(null, projectile_instance, fire_position.global_position, direction)
	elif projectile_instance is Projectile:
		GlobalSignals.projectile_fired_spawn.emit(null, projectile_instance, fire_position.global_position, direction)

func set_projectile_variables(projectile: Projectile):
	projectile.speed = projectile_speed
	projectile.damages = projectile_damages
	projectile.scale *= projectile_size
	projectile.impact_force = projectile_impact_force
	projectile.piercing_force = projectile_piercing_force
	projectile.should_bounce = projectile_should_bounce
	projectile.should_pierce_walls = projectile_should_pierce_walls
	projectile.should_frag = projectile_should_frag
	frag_projectile_precision_angle = frag_projectile_precision_angle
	frag_projectile_precision = frag_projectile_precision
	number_of_frag_projectile = number_of_frag_projectile

func add_charge_power_points(points: int):
	current_points_to_use_special_power += points
	if current_points_to_use_special_power >= points_to_use_special_power:
		can_use_power = true
		current_points_to_use_special_power = 0
	else:
		can_use_power = false

func reload_magazine():
	if shooter_actor is Player:
		GlobalSignals.player_reloading.emit(ammo_reloading_time)
	
	var pitch_scale:float =  reloading_sound.get_length() / ammo_reloading_time
	GlobalSignals.play_sound.emit(reloading_sound, 1, pitch_scale, global_position)

	await get_tree().create_timer(ammo_reloading_time).timeout
	_current_loader_bullets_number = ammo_size
