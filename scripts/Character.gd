extends CharacterBody2D
class_name Character

@onready var health = $Health as Health
@onready var weapon_position = $WeaponPosition

@export var speed : float = 6
var force : Vector2 = Vector2.ZERO

var has_weapon : bool = true
@export var weapon_manager : Node2D = null

var has_knife : bool = true
@export var knife : Knife = null

#var has_grappling_hook : bool = true
#@export var grappling_hook : Node2D = null

#var has_bulletproof_vest : bool = true
#var bulletproof_vest : Node2D = null

#@export var passive_effect_list : Dictionary

#func _ready():
#	GlobalSignals.connect("bullet_fired_force", Callable(self, "apply_force"))

func throwProjectile(projectile_weapon: PackedScene, throw_position: Vector2, sprite: Sprite2D = null):
	var projectile_instance = projectile_weapon.instantiate()
	var direction = throw_position - global_position
	if projectile_instance.has_method("set_sprite") && sprite != null:
		projectile_instance.set_sprite(sprite)
	GlobalSignals.projectile_fired_spawn.emit(self, projectile_instance, throw_position, direction)

func stunned(time_to_sleep: float):
	var save_speed = speed
	speed = 0
	await get_tree().create_timer(time_to_sleep).timeout
	speed = save_speed

func apply_force(character: Character, direction: Vector2, force: float):
	character.force = direction * force

