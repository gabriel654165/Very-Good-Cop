extends CharacterBody2D
class_name Character

@onready var health = $Health as Health
@onready var weapon_position = $WeaponPosition
@onready var throw_object_position = $ThrowObjectPosition

#movement
@export var speed : float = 6
var force : Vector2 = Vector2.ZERO

#if player, don't show / private
@export var weapon_manager : Node2D = null
@export var knife : Knife = null

#if enemy don't show
@export var grappling_hook_scene : PackedScene
@export var projectile_weapon_scene : PackedScene

#var has_bulletproof_vest : bool = true
#var bulletproof_vest : Node2D = null

var weapon_throwed : bool = false
var hook_deployed : bool = false

func stab():
	if knife != null:
		knife.stab()

func throw_grappling():
	hook_deployed = true
	throwProjectile(grappling_hook_scene, throw_object_position.global_position)

func throw_weapon():
	if weapon_manager.weapon != null:
		throwProjectile(projectile_weapon_scene, throw_object_position.global_position, weapon_manager.weapon.side_sprite)
		weapon_manager.enable = false
		weapon_manager.weapon.sprite.visible = false
		weapon_throwed = true

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

