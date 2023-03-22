extends Node2D
class_name Weapon

signal weapon_fired(bullet, location, direction)

@export var Bullet : PackedScene

#changer ces deux pareamètre par fréquence & amplitude (3 balles (fréqeunce) en 1s(amplitude))
@export var number_of_balls_by_burt : int = 1
@export var frequence_of_burt : float = 0.1 #time between balls of burts
@export var precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
@export var precision : float = 0 # the more it's close 0 the more it's precise
@export var recoil_force : float = 2 # the more it's close 0 the more it's precise

#armes : grapin
#arme : ~granade

#bullet : distance de free & pas timer
#bullet : ricochet 1 fois sur les murs
#bullet ; saignement

@onready var fire_position = $FirePosition
@onready var fire_direction = $FireDirection
@onready var attack_cooldown = $AttackCoolDown
@onready var animation = $Animation

func _ready():
	randomize()

func shoot():
	if attack_cooldown.is_stopped() and Bullet != null:
		attack_cooldown.start()
		
		for n in number_of_balls_by_burt:
			if n != 0:
				await get_tree().create_timer(frequence_of_burt).timeout
			var bullet_instance = Bullet.instantiate()
			var direction = fire_direction.global_position - fire_position.global_position
			
			direction += Vector2(_random_range(precision_angle), 0)#random direction (x), same distance (y)
			GlobalSignals.emit_signal("bullet_fired_spawn", bullet_instance, fire_position.global_position, direction)
			GlobalSignals.emit_signal("bullet_fired_force", get_parent(), -direction, recoil_force)
			animation.play("muzzle_flash")

#return a random float between x and y
func _random_range(angle: Vector2) -> float:
	var range : float = 0
	if randf()>0.5: #1 out of 2 chances
		range = randf()*angle.x
	else:
		range = randf()*angle.y
	range *= precision
	return range
