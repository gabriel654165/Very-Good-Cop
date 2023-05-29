extends Character
class_name Player

@export var index_weapon_selected : int = 1
@export var weapon_list : Dictionary

var move_direction : Vector2 = Vector2.ZERO
@onready var sound_shoot_vfx: CPUParticles2D = $ShootVFX

func _ready():
	await assign_weapon(index_weapon_selected)
	assign_knife()

func _physics_process(delta):
	if self.action_disabled:
		return
	manage_movement(delta)
	manage_rotation()


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
		throw_weapon()
	if event.is_action_pressed("throw_grappling") and !hook_deployed and GlobalVariables.grappling_hook_level != 0:
		throw_grappling()
	if event.is_action_pressed("activate_special_power") and weapon_manager.weapon.can_use_power and !weapon_manager.weapon.special_power.activated:
		weapon_manager.weapon.special_power.use_special_power()
	
	#switch weapon
	if event.is_action_pressed("test"):
		index_weapon_selected += 1
		if index_weapon_selected > weapon_list.size():
			index_weapon_selected = 1
		print("weapon index : ", index_weapon_selected)
		unassign_weapon()
		assign_weapon(index_weapon_selected)

func assign_knife():
	knife = GlobalVariables.all_knife_scene_list[GlobalVariables.index_knife_selected].packed_scene.instantiate()
	add_child(knife)
	knife.global_position = global_position

func set_active_assigned_weapon():
	weapon_throwed = false
	weapon_manager.enable = true
	#weapon_manager.weapon.sprite.visible = true

func assign_weapon(index: int):
	weapon_manager = await find_weapon(index_weapon_selected)
	if weapon_manager == null:
		return
	weapon_manager.set_position(weapon_position.position)
	self.add_child(weapon_manager)
	weapon_manager.set_variables(weapon_manager.weapon)

func unassign_weapon():
	if weapon_manager == null:
		return
	weapon_manager.queue_free()

func find_weapon(weapon_index: int) -> Object :
	var current_index : int = 1 
	var weapon_scene : Object = null 
	
	if weapon_list == null or weapon_list.size() <= 0:
		return null
	
	for key_weapon in weapon_list.keys():
		if current_index == weapon_index:
			weapon_scene = weapon_list[key_weapon]
		current_index += 1
	
	if weapon_scene == null:
		return null
	
	var weapon_manager : Node2D = await weapon_scene.instantiate()
	return weapon_manager

func handle_enemy_died(enemy: Node2D, points: int):
	if weapon_manager.weapon.special_power_unlocked:
		weapon_manager.weapon.add_charge_power_points(points)

func handle_hit(damager: Node2D, damages):
	health.hit(damages)
