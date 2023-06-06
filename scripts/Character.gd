extends CharacterBody2D
class_name Character

@onready var health = $Health as Health
@onready var weapon_manager : Node2D = $WeaponPosition/WeaponManager
@onready var weapon_position = $WeaponPosition
@onready var knife : Knife = $Knife
@onready var throw_object_position = $ThrowObjectPosition
@onready var body_animation = $BodyAnimation
@onready var legs_animation = $LegsAnimation
@onready var legs_sprite := $LegsSprite2D
@onready var body_sprite := $Sprite2D

@export var action_disabled : bool = false
@export var speed : float = 6
var force : Vector2 = Vector2.ZERO


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
		weapon_manager.weapon.enable = false
		weapon_throwed = true

func recover_weapon():
	weapon_throwed = false
	weapon_manager.enable = true
	weapon_manager.weapon.enable = true
	set_body_animation(self)


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


func handle_character_shoot(projectile_owner: Node2D):
	var animation_name : String = ""
	if projectile_owner is Player:
		animation_name = GlobalVariables.get_distance_weapon_animation_by_index(GlobalVariables.index_distance_weapon_selected)
		animation_name += "_player_shoot"
	elif projectile_owner is Enemy:
		animation_name = GlobalVariables.get_distance_weapon_animation_by_name(projectile_owner.weapon_manager.weapon_name)
		animation_name += "_enemy_shoot"
	projectile_owner.body_animation.play(animation_name)


func play_animation(name: String, player: AnimationPlayer):
	if self is Player:
		player.play(name + "_player")
	if self is Enemy:
		player.play(name + "_enemy")

func manage_animation(move_direction: Vector2):
	if move_direction == Vector2.ZERO or velocity == Vector2.ZERO:
		legs_animation.stop()
		if weapon_throwed or weapon_manager == null:
			play_animation("idle_animation", body_animation)
	else:
		play_animation("running_animation", legs_animation)
		if weapon_throwed or weapon_manager == null:
			play_animation("running_animation", body_animation)
	legs_sprite.global_rotation = move_direction.angle()


func set_weapon_position(character: Character):
	var weapon_pos : Vector2 = Vector2.ZERO
	if character is Player:
		weapon_pos = GlobalVariables.get_distance_weapon_position_by_index(GlobalVariables.index_distance_weapon_selected)
	elif character is Enemy:
		weapon_pos = GlobalVariables.get_distance_weapon_position_by_name(character.weapon_manager.weapon_name)
	character.weapon_position.position = weapon_pos


func set_body_animation(character: Character):
	var animation_name : String = ""
	if character is Player:
		animation_name = GlobalVariables.get_distance_weapon_animation_by_index(GlobalVariables.index_distance_weapon_selected)
		animation_name += "_player"
	elif character is Enemy:
		animation_name = GlobalVariables.get_distance_weapon_animation_by_name(character.weapon_manager.weapon_name)
		animation_name += "_enemy"
	character.body_animation.play(animation_name)


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
