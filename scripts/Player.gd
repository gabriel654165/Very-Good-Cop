extends Character
class_name Player

@export var index_weapon_selected : int = 1
#mettre que les weapons qu'il a 
# ps : faire un playerEditor / EnemyEditor
@export var weapon_list : Dictionary

@export var projectile_weapon : PackedScene

var move_direction : Vector2 = Vector2.ZERO
var weapon_throwed : bool = false

@onready var launch_weapon_position = $LaunchWeaponPosition

func _ready():
	await assign_weapon(index_weapon_selected)
	assign_knife()
	update_passive_effects()

func _physics_process(delta):
	var move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if self.force != Vector2.ZERO:
		velocity += self.force
		self.force = Vector2.ZERO
		
	if move_direction != Vector2.ZERO:
		velocity += move_direction * GlobalFunctions.get_speed(delta, speed) + self.force
	global_position += velocity
	move_and_slide()
	velocity = Vector2.ZERO
	look_at(get_global_mouse_position())

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if weapon_manager != null:
			weapon_manager.weapon.shoot()

func _unhandled_input(event):
	if event.is_action_pressed("stab"):
		if knife != null:
			knife.stab()
	
	if event.is_action_pressed("throw_weapon") && !weapon_throwed:
		#if weapon_manager != null:
		#if weapon.state == true:
		throwProjectile(projectile_weapon, launch_weapon_position.global_position)
		weapon_throwed = true
		#désactiver/retirer son weapon dans l'array
	
	if event.is_action_pressed("test"):
		index_weapon_selected += 1
		if index_weapon_selected > weapon_list.size():
			index_weapon_selected = 1
		print("weapon index : ", index_weapon_selected)
		unassign_weapon()
		assign_weapon(index_weapon_selected)

func update_passive_effects():
	pass

func assign_knife():
	knife = GlobalVariables.knife_scene.instantiate()
	add_child(knife)
	knife.global_position = global_position

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

func handle_hit(damages):
	health.hit(damages)
