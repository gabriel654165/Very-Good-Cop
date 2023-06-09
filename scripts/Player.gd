extends Character
class_name Player

var move_direction : Vector2 = Vector2.ZERO
@onready var sound_shoot_vfx: CPUParticles2D = $ShootVFX

func _ready():
	GlobalSignals.weapon_shoot.connect(self.handle_shoot)
	GlobalSignals.weapon_stab.connect(self.handle_stab)
	GlobalSignals.throwed_distance_weapon.connect(self.handle_throwed_distance_weapon)
	assign_equipment()
	# Test : skipping the choose weapons panel and take the global
	assign_weapons()


func assign_equipment():
	GlobalFunctions.set_equipment_properties(self)


func assign_weapons():
	GlobalFunctions.set_distance_weapon_properties(weapon_manager, GlobalVariables.index_distance_weapon_selected)
	set_weapon_position()
	set_body_animation()
	GlobalFunctions.set_melee_weapon_properties(knife, GlobalVariables.index_melee_weapon_selected)
	GlobalFunctions.set_throwable_object_properties(throwable_object_manager, GlobalVariables.index_throwable_object_selected)


func _physics_process(delta):
	if self.action_disabled:
		return
	manage_movement(delta)
	manage_rotation()
	manage_animation(move_direction)


func manage_movement(delta: float):
	velocity = Vector2.ZERO
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
	if Input.is_action_pressed("stab"):
		knife.stab()
	

func _unhandled_input(event):
	if self.action_disabled:
		return
	if event.is_action_pressed("reload_weapon") and !distance_weapon_throwed and weapon_manager.weapon != null and weapon_manager.weapon._current_loader_bullets_number < weapon_manager.weapon.ammo_size:
		weapon_manager.weapon.reload_magazine()
	if event.is_action_pressed("throw_throwable_object") and throwable_object_manager != null:
		throwable_object_manager.throw()
	if event.is_action_pressed("throw_distance_weapon") and !distance_weapon_throwed and weapon_manager.weapon != null:
		throw_distance_weapon()
		GlobalSignals.throwed_distance_weapon.emit(self)
	if event.is_action_pressed("throw_melee_weapon") and !melee_weapon_throwed and knife != null and knife.can_throw:
		throw_melee_weapon()
	if event.is_action_pressed("use_special_power") and weapon_manager.weapon.can_use_power and !weapon_manager.weapon.special_power.activated:
		weapon_manager.weapon.special_power.use_special_power()


func assign_knife():
	knife = GlobalVariables.all_knife_scene_list[GlobalVariables.index_melee_weapon_selected].packed_scene.instantiate()
	add_child(knife)
	knife.global_position = global_position


func handle_enemy_died(enemy: Node2D, points: int):
	var index : int = GlobalVariables.index_distance_weapon_selected
	if GlobalVariables.player_distance_weapon_list[index].special_power_unlocked:
		weapon_manager.weapon.add_charge_power_points(points)


func handle_hit(damager: Node2D, damages):
	health.hit(damages)
	if health.is_dead() and !is_dead:
		is_dead = true
		var corpse_inst = instanciate_corpse(self.global_position, get_tree().current_scene, damager)
		GlobalSignals.game_over.emit()
		queue_free()
	else:
		instanciate_blood_effect(self.global_position, get_tree().current_scene, damager)
