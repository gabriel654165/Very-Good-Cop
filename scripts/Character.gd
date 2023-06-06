extends CharacterBody2D
class_name Character

@onready var health = $Health as Health
@onready var weapon_position = $WeaponPosition
@onready var throw_object_position = $ThrowObjectPosition
@onready var weapon_animation = $WeaponAnimation
@onready var legs_animation = $LegsAnimation
@onready var legs_sprite := $LegsSprite2D
@onready var body_sprite := $Sprite2D

@export var action_disabled : bool = false
@export var speed : float = 6
var force : Vector2 = Vector2.ZERO

@export var weapon_manager : Node2D = null
@export var knife : Knife = null

@export var grappling_hook_scene : PackedScene
@export var projectile_weapon_scene : PackedScene

var weapon_throwed : bool = false
var hook_deployed : bool = false

@export var blood_effect_scene : PackedScene
@export var corpse_scene : PackedScene

var is_dead : bool = false

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

func set_able_actions(state: bool):
	action_disabled = state


func set_weapon_position(character: Character):
	var weapon_pos : Vector2 = Vector2.ZERO
	if character is Player:
		weapon_pos = GlobalVariables.get_distance_weapon_position_by_index(GlobalVariables.index_distance_weapon_selected)
	elif character is Enemy:
		weapon_pos = GlobalVariables.get_distance_weapon_position_by_name(character.weapon_manager.weapon_name)
	character.weapon_position.position = weapon_pos

func set_weapon_animation(character: Character):
	var animation_name : String = ""
	if character is Player:
		animation_name = GlobalVariables.get_distance_weapon_animation_by_index(GlobalVariables.index_distance_weapon_selected)
		animation_name += "_player"
	elif character is Enemy:
		animation_name = GlobalVariables.get_distance_weapon_animation_by_name(character.weapon_manager.weapon_name)
		animation_name += "_enemy"
	character.weapon_animation.play(animation_name)


func spawnSprite(position: Vector2, sprite: Sprite2D) -> Node2D:
	var spriteDeadEnemy = Sprite2D.new()
	spriteDeadEnemy.set_name("SpriteDead")
	spriteDeadEnemy.texture = sprite.texture
	spriteDeadEnemy.visible = true
	get_tree().current_scene.add_child(spriteDeadEnemy)
	spriteDeadEnemy.global_position = position
	return spriteDeadEnemy as Node2D

func instanciate_corpse(position: Vector2, parent: Node, damager: Node2D) -> Node:
	var inst = corpse_scene.instantiate()
	parent.add_child(inst)
	inst.global_position = position
	inst.type = Corpse.CorpseType.POLICE if self is Player else Corpse.CorpseType.CARTEL
	if damager is Projectile:
		var new_velocity: Vector2 = (damager as Projectile).direction
		new_velocity = new_velocity.normalized()
		inst.global_rotation = new_velocity.angle()
	inst.display_corpse()
	return inst

func instanciate_blood_effect(position: Vector2, parent: Node, damager: Node2D):
	var inst = blood_effect_scene.instantiate()
	parent.add_child(inst)
	if damager is Projectile:
		var new_velocity : Vector2 = damager.direction.normalized()
		inst.get_node("SubViewportContainer/PixelizedSubViewport/SquareBloodParticles").set_rotation(new_velocity.angle())
		inst.get_node("SubViewportContainer/PixelizedSubViewport/CircleBloodParticles").set_rotation(new_velocity.angle())
	inst.global_position = position - inst.size / 2
