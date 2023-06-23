extends CharacterBody2D
class_name Character

@onready var health = $Health as Health
@onready var weapon_manager : Node2D = $WeaponPosition/WeaponManager
@onready var weapon_position = $WeaponPosition
@onready var knife : Knife = $Knife
@onready var throw_object_position = $ThrowObjectPosition
@onready var throwable_object_manager : ThrowableObjectManager = $ThrowObjectPosition/ThrowableObjectManager
@onready var body_animation = $BodyAnimation
@onready var legs_animation = $LegsAnimation
@onready var legs_sprite := $LegsSprite2D
@onready var body_sprite := $Sprite2D

@export var action_disabled : bool = false
@export var speed : float = 2.5
@export var base_speed : float = 2.5

@export var blood_effect_scene : PackedScene
@export var corpse_scene : PackedScene

@export var projectile_weapon_scene : PackedScene

var distance_weapon_throwed : bool = false
var melee_weapon_throwed : bool = false
var hook_deployed : bool = false

var force : Vector2 = Vector2.ZERO
var is_dead : bool = false


func throw_melee_weapon():
	if knife != null:
		throwProjectile(projectile_weapon_scene, throw_object_position.global_position, ProjectileTypes.Type.MELEE_WEAPON, knife.side_sprite)
		knife.enable = false
		melee_weapon_throwed = true


func throw_distance_weapon():
	if weapon_manager.weapon != null:
		throwProjectile(projectile_weapon_scene, throw_object_position.global_position, ProjectileTypes.Type.DISTANCE_WEAPON, weapon_manager.weapon.side_sprite)
		weapon_manager.enable = false
		weapon_manager.weapon.enable = false
		distance_weapon_throwed = true


func recover_weapon(weapon_type: ProjectileTypes.Type):
	if weapon_type == ProjectileTypes.Type.DISTANCE_WEAPON:
		distance_weapon_throwed = false
		weapon_manager.enable = true
		weapon_manager.weapon.enable = true
	elif weapon_type == ProjectileTypes.Type.MELEE_WEAPON:
		melee_weapon_throwed = false
		knife.enable = true
	set_body_animation()


func throwProjectile(projectile_weapon: PackedScene, throw_position: Vector2, type: ProjectileTypes.Type = ProjectileTypes.Type.PROJECTILE_WEAPON, sprite: Sprite2D = null):
	var projectile_instance := projectile_weapon.instantiate()
	var direction = throw_position - global_position
	projectile_instance.set_projectile_type(type)
	if projectile_instance.has_method("set_sprite") && sprite != null:
		projectile_instance.set_sprite(sprite)
	GlobalSignals.projectile_fired_spawn.emit(self, projectile_instance, throw_position, direction)


func stop_all_processes(node: Node, state: bool):
	for child in node.get_children():
		if child is AnimationPlayer or child is Sprite2D:
			continue
		if child.get_child_count() > 0:
			stop_all_processes(child, state)
		GlobalFunctions.disable_all_process(child, state)
	GlobalFunctions.disable_all_process(self, state)
	return


func stunned(time_to_sleep: float):
	body_animation.play("stunned_animation")
	if self is Player:
		action_disabled = true
	else:
		stop_all_processes(self, true)
	await get_tree().create_timer(time_to_sleep).timeout
	if self is Player:
		action_disabled = false
	else:
		stop_all_processes(self, false)
	body_animation.play("stand_up_animation")


func apply_force(character: Character, direction: Vector2, force: float):
	character.force = direction * force


func play_animation(name: String, animation_player: AnimationPlayer, suffix: String = ""):
	if self is Player:
		animation_player.play(name + "_player" + suffix)
	if self is Enemy:
		animation_player.play(name + "_enemy" + suffix)


func handle_stab(actor: Node):
	if knife != null:
		var animation_name : String = ""
		if actor is Player and self is Player:
			animation_name = GlobalFunctions.get_melee_weapon_animation_by_index(GlobalVariables.index_melee_weapon_selected)
			play_animation(animation_name, actor.body_animation)
		elif actor is Enemy and self is Enemy:
			animation_name = GlobalFunctions.get_melee_weapon_animation_by_name(actor.knife.weapon_name)
			play_animation(animation_name, actor.body_animation)

func handle_shoot(actor: Node):
	var animation_name : String = ""
	if actor is Player and self is Player:
		animation_name = GlobalFunctions.get_distance_weapon_animation_by_index(GlobalVariables.index_distance_weapon_selected)
		play_animation(animation_name, actor.body_animation, "_shoot")
	elif actor is Enemy and self is Enemy:
		animation_name = GlobalFunctions.get_distance_weapon_animation_by_name(actor.weapon_manager.weapon_name)
		play_animation(animation_name, actor.body_animation, "_shoot")

func handle_throwed_distance_weapon(actor: Node):
	if actor is Player and self is Player:
		play_animation("idle_animation", actor.body_animation)
	if actor is Enemy and self is Enemy:
		play_animation("idle_animation", actor.body_animation)


func manage_animation(move_direction: Vector2):
	if move_direction == Vector2.ZERO or velocity == Vector2.ZERO:
		legs_animation.stop()
	else:
		play_animation("running_animation", legs_animation)
	legs_sprite.global_rotation = move_direction.angle()

func set_body_animation():
	if distance_weapon_throwed:
		play_animation("idle_animation", self.body_animation)
		return
	var animation_name : String = ""
	if self is Player:
		animation_name = GlobalFunctions.get_distance_weapon_animation_by_index(GlobalVariables.index_distance_weapon_selected)
	elif self is Enemy:
		animation_name = GlobalFunctions.get_distance_weapon_animation_by_name(self.weapon_manager.weapon_name)
	play_animation(animation_name, self.body_animation)


func set_weapon_position():
	var weapon_pos : Vector2 = Vector2.ZERO
	if self is Player:
		weapon_pos = GlobalVariables.get_distance_weapon_position_by_index(GlobalVariables.index_distance_weapon_selected)
	elif self is Enemy:
		weapon_pos = GlobalVariables.get_distance_weapon_position_by_name(self.weapon_manager.weapon_name)
	self.weapon_position.position = weapon_pos


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
