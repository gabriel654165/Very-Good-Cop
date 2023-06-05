extends Character
class_name Player

var move_direction : Vector2 = Vector2.ZERO
@onready var sound_shoot_vfx: CPUParticles2D = $ShootVFX
@onready var weapon_animation_player = $WeaponAnimationPlayer
@onready var legs_animation_player = $LegsAnimationPlayer
@onready var legs_sprite := $LegsSprite2D

func _ready():
	# Test : skipping the choose weapons panel and take the global
	assign_weapons()


func assign_weapons():
	GlobalFunctions.set_distance_weapon_properties(weapon_manager, GlobalVariables.index_distance_weapon_selected)
	set_weapon_position()
	set_weapon_animation()


func set_weapon_position():
	var position := GlobalVariables.get_distance_weapon_position(GlobalVariables.index_distance_weapon_selected)
	weapon_position.position = position

func set_weapon_animation():
	var animation_name := GlobalVariables.get_distance_weapon_animation(GlobalVariables.index_distance_weapon_selected)
	weapon_animation_player.play(animation_name + "_player")

#callback signal player shoot / voir pour les enemis
func play_shoot_animation(projectile_owner: Node2D):
	if projectile_owner is Player:
		var animation_name := GlobalVariables.get_distance_weapon_animation(GlobalVariables.index_distance_weapon_selected)
		weapon_animation_player.play(animation_name + "_player_shoot")

func manage_animation():
	if move_direction == Vector2.ZERO:
		legs_animation_player.stop()
	else:
		legs_animation_player.play("runing_player")
	legs_sprite.global_rotation = move_direction.angle()


func _physics_process(delta):
	if self.action_disabled:
		return
	manage_movement(delta)
	manage_rotation()
	manage_animation()


func manage_movement(delta: float):
	move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if self.force != Vector2.ZERO:
		velocity += self.force
		self.force = Vector2.ZERO
	
	if move_direction != Vector2.ZERO:
		velocity += move_direction.normalized() * GlobalFunctions.get_speed(delta, speed)
	velocity *= 100
	move_and_slide()
	velocity = Vector2.ZERO

func manage_rotation():
	var direction : Vector2 = Vector2.ZERO
	
	if !weapon_manager.weapon.special_power.activated or (weapon_manager.weapon.special_power.activated and (!weapon_manager.weapon.special_power.disable_look_at and weapon_manager.weapon.special_power.player_target == Vector2.ZERO)):
		direction = get_canvas_transform().affine_inverse() * GlobalVariables.cursor_position
	elif weapon_manager.weapon.special_power.player_target != Vector2.ZERO and !weapon_manager.weapon.special_power.disable_look_at:
		direction = weapon_manager.weapon.special_power.player_target
	if direction != Vector2.ZERO:
		look_at(direction)

func _process(delta):
	if self.action_disabled:
		return
	if Input.is_action_pressed("shoot"):
		var shoot_prohibited : bool = false
		
		if "is_shooting" in weapon_manager.weapon.special_power:
			shoot_prohibited = weapon_manager.weapon.special_power.is_shooting
		
		if weapon_manager != null and !shoot_prohibited:
			weapon_manager.weapon.shoot()


func _unhandled_input(event):
	if self.action_disabled:
		return
	if event.is_action_pressed("stab"):
		stab()
	if event.is_action_pressed("throw_weapon") and !weapon_throwed and weapon_manager.weapon != null:
		#changer l'animation
		throw_weapon()
	if event.is_action_pressed("throw_grappling") and !hook_deployed and GlobalVariables.grappling_hook_level != 0:
		throw_grappling()
	if event.is_action_pressed("use_special_power") and weapon_manager.weapon.can_use_power and !weapon_manager.weapon.special_power.activated:
		weapon_manager.weapon.special_power.use_special_power()

func assign_knife():
	knife = GlobalVariables.all_knife_scene_list[GlobalVariables.index_melee_weapon_selected].packed_scene.instantiate()
	add_child(knife)
	knife.global_position = global_position

func set_active_assigned_weapon():
	weapon_throwed = false
	weapon_manager.enable = true
	#weapon_manager.weapon.sprite.visible = true
	#changer l'animation

func handle_enemy_died(enemy: Node2D, points: int):
	var index : int = GlobalVariables.index_distance_weapon_selected
	if GlobalVariables.player_distance_weapon_list[index].special_power_unlocked:
		weapon_manager.weapon.add_charge_power_points(points)

func handle_hit(damager: Node2D, damages):
	health.hit(damages)
