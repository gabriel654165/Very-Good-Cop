@tool
extends Node2D
class_name WeaponEditor

var saved_property_list : Array = []
var weapon : Node

var weapon_name : String

var points_to_use_special_power : int = 2
var current_points_to_use_special_power : int = 0
var can_use_power : bool = false

var projectile_scene : PackedScene
var projectile_speed : int = 6
var projectile_damages : int = 6
var projectile_size : float = 0.5
var projectile_impact_force : float = 2
var projectile_piercing_force : int = 0
var projectile_should_bounce : bool = false
var projectile_should_pierce_walls : bool = false

var projectile_should_frag : bool = false
var frag_projectile_precision_angle : Vector2 = Vector2(-1, 1)#coordonées de trigo
var frag_projectile_precision : float = 1
var number_of_frag_projectile : int = 3

var ammo_size : int = 6
var ammo_reloading_time : float = 1

var enable : bool = true
var shooting_cooldown : float = 0.5
var balls_by_burt : int = 1
var frequence_of_burt : float = 0
var precision_angle : Vector2 = Vector2(-1, 1)
var precision : float = 0
var recoil_force : float = 2
var auto_lock_target : bool = false

var special_power : SpecialPower

func _ready():
	weapon = self.get_child(0) as Weapon
	if weapon == null:
		return
	set_variables(weapon)
	saved_property_list = _get_property_list()

func _process(delta):
	#if not Engine.is_editor_hint():
	#	set_variables(weapon)
	if Engine.is_editor_hint() and _get_property_list() != saved_property_list:
		self.notify_property_list_changed()
		saved_property_list = _get_property_list()

func set_pos(position):
	weapon.global_position = position

func set_projectile(new_projectile: PackedScene):
	self.Projectile = new_projectile
	weapon.Projectile = new_projectile

func set_variables(new_weapon: Weapon, upadte_projectile: bool = true, update_nodes: bool = true):
	if weapon == null:
		weapon = new_weapon
	
	weapon.weapon_name = self.weapon_name
	
	weapon.points_to_use_special_power = self.points_to_use_special_power
	weapon.current_points_to_use_special_power = self.current_points_to_use_special_power
	weapon.can_use_power = self.can_use_power
	
	if upadte_projectile:
		weapon.projectile_scene = self.projectile_scene
	weapon.projectile_speed = self.projectile_speed
	weapon.projectile_damages = self.projectile_damages
	weapon.projectile_size = self.projectile_size
	weapon.projectile_impact_force = self.projectile_impact_force
	weapon.projectile_piercing_force = self.projectile_piercing_force
	weapon.projectile_should_bounce = self.projectile_should_bounce
	weapon.projectile_should_pierce_walls = self.projectile_should_pierce_walls
	
	weapon.projectile_should_frag = self.projectile_should_frag
	weapon.frag_projectile_precision_angle = self.frag_projectile_precision_angle
	weapon.frag_projectile_precision = self.frag_projectile_precision
	weapon.number_of_frag_projectile = self.number_of_frag_projectile
	
	weapon.ammo_size = self.ammo_size
	weapon._current_loader_bullets_number = self.ammo_size
	weapon.ammo_reloading_time = self.ammo_reloading_time
	
	weapon.enable = self.enable
	weapon.shooting_cooldown.wait_time = self.shooting_cooldown
	weapon.balls_by_burt = self.balls_by_burt
	weapon.frequence_of_burt = self.frequence_of_burt
	weapon.precision_angle = self.precision_angle
	weapon.precision = self.precision
	weapon.recoil_force = self.recoil_force
	weapon.auto_lock_target = self.auto_lock_target
	
	weapon.special_power = self.special_power

func _get(property):
	if property == 'properties/weapon_name':
		return weapon_name
	
	if property == 'power/points_to_use_special_power':
		return points_to_use_special_power
	if property == 'power/current_points_to_use_special_power':
		return current_points_to_use_special_power
	if property == 'power/can_use_power':
		return can_use_power
	
	if property == 'projectile/projectile':
		return projectile_scene
	if property == 'projectile/projectile_speed':
		return projectile_speed
	if property == 'projectile/projectile_damages':
		return projectile_damages
	if property == 'projectile/projectile_size':
		return projectile_size
	if property == 'projectile/projectile_impact_force':
		return projectile_impact_force
	if property == 'projectile/projectile_piercing_force':
		return projectile_piercing_force
	if property == 'projectile/projectile_should_bounce':
		return projectile_should_bounce

	if property == 'projectile/projectile_should_pierce_walls':
		return projectile_should_pierce_walls
	if property == 'projectile/projectile_should_frag':
		return projectile_should_frag
	if property == 'projectile/frag_projectile_precision_angle':
		return frag_projectile_precision_angle
	if property == 'projectile/frag_projectile_precision':
		return frag_projectile_precision
	if property == 'projectile/number_of_frag_projectile':
		return number_of_frag_projectile
	
	if property == 'ammo/ammo_size':
		return ammo_size
	if property == 'ammo/ammo_reloading_time':
		return ammo_reloading_time
	
	if property == 'weapon/enable':
		return enable
	if property == 'weapon/shooting_cooldown':
		return shooting_cooldown
	if property == 'weapon/balls_by_burt':
		return balls_by_burt
	if property == 'weapon/frequence_of_burt':
		return frequence_of_burt
	if property == 'weapon/precision_angle':
		return precision_angle
	if property == 'weapon/precision':
		return precision
	if property == 'weapon/recoil_force':
		return recoil_force
	if property == 'weapon/auto_lock_target':
		return auto_lock_target

func _set(property, value) -> bool :
	if property == 'properties/weapon_name':
		weapon_name = value
	
	if property == 'power/points_to_use_special_power':
		points_to_use_special_power = value
	if property == 'power/current_points_to_use_special_power':
		current_points_to_use_special_power = value
	if property == 'power/can_use_power':
		can_use_power = value
	
	if property == 'projectile/projectile':
		projectile_scene = value
	if property == 'projectile/projectile_speed':
		projectile_speed = value
	if property == 'projectile/projectile_damages':
		projectile_damages = value
	if property == 'projectile/projectile_size':
		projectile_size = value
	if property == 'projectile/projectile_impact_force':
		projectile_impact_force = value
	if property == 'projectile/projectile_piercing_force':
		projectile_piercing_force = value
	if property == 'projectile/projectile_should_bounce':
		projectile_should_bounce = value

	if property == 'projectile/projectile_should_pierce_walls':
		projectile_should_pierce_walls = value
	if property == 'projectile/projectile_should_frag':
		projectile_should_frag = value
	if property == 'projectile/frag_projectile_precision_angle':
		frag_projectile_precision_angle = value
	if property == 'projectile/frag_projectile_precision':
		frag_projectile_precision = value
	if property == 'projectile/number_of_frag_projectile':
		number_of_frag_projectile = value
	
	if property == 'ammo/ammo_size':
		ammo_size = value
	if property == 'ammo/ammo_reloading_time':
		ammo_reloading_time = value
	
	if property == 'weapon/enable':
		enable = value
	if property == 'weapon/shooting_cooldown':
		shooting_cooldown = value
	if property == 'weapon/balls_by_burt':
		balls_by_burt = value
	if property == 'weapon/frequence_of_burt':
		frequence_of_burt = value
	if property == 'weapon/precision_angle':
		precision_angle = value
	if property == 'weapon/precision':
		precision = value
	if property == 'weapon/recoil_force':
		recoil_force = value
	if property == 'weapon/auto_lock_target':
		auto_lock_target = value
	return true


func _get_property_list() -> Array:
	var props = []
	
	var props_proprieties = [{
		'name': 'properties/weapon_name',
		'type': TYPE_STRING,
	}]
	
	var props_power = [{
		'name': 'power/points_to_use_special_power',
		'type': TYPE_INT,
	},{
		'name': 'power/current_points_to_use_special_power',
		'type': TYPE_INT,
	},{
		'name': 'power/can_use_power',
		'type': TYPE_BOOL,
	}]
	
	var props_projectile = [{
		'name': 'projectile/projectile',
		'type': TYPE_OBJECT,
	},{
		'name': 'projectile/projectile_speed',
		'type': TYPE_INT,
	},{
		'name': 'projectile/projectile_damages',
		'type': TYPE_INT,
	},{
		'name': 'projectile/projectile_size',
		'type': TYPE_FLOAT,
	},{
		'name': 'projectile/projectile_impact_force',
		'type': TYPE_FLOAT,
	},{
		'name': 'projectile/projectile_piercing_force',
		'type': TYPE_INT,
	},{
		'name': 'projectile/projectile_should_bounce',
		'type': TYPE_BOOL,
	},{
		'name': 'projectile/projectile_should_pierce_walls',
		'type': TYPE_BOOL,
	}]
	
	var props_frag_projectiles = [{
		'name': 'projectile/projectile_should_frag',
		'type': TYPE_BOOL,
	}]
	
	if projectile_should_frag:
		props_frag_projectiles.append_array(
	[{
		'name': 'projectile/frag_projectile_precision_angle',
		'type': TYPE_VECTOR2,
	},{
		'name': 'projectile/frag_projectile_precision',
		'type': TYPE_FLOAT,
	},{
		'name': 'projectile/number_of_frag_projectile',
		'type': TYPE_INT,
	}])
	
	var props_loader = [{
		'name': 'ammo/ammo_size',
		'type': TYPE_INT,
	},{
		'name': 'ammo/ammo_reloading_time',
		'type': TYPE_FLOAT,
	}]
	
	var props_weapon = [{
		'name': 'weapon/enable',
		'type': TYPE_BOOL,
	},{
		'name': 'weapon/shooting_cooldown',
		'type': TYPE_FLOAT,
	},{
		'name': 'weapon/balls_by_burt',
		'type': TYPE_INT,
	},{
		'name': 'weapon/frequence_of_burt',
		'type': TYPE_FLOAT,
	},{
		'name': 'weapon/precision_angle',
		'type': TYPE_VECTOR2,
	},{
		'name': 'weapon/precision',
		'type': TYPE_FLOAT,
	},{
		'name': 'weapon/recoil_force',
		'type': TYPE_FLOAT,
	},{
		'name': 'weapon/auto_lock_target',
		'type': TYPE_BOOL,
	}]

	props.append_array(props_proprieties)
	props.append_array(props_power)
	props.append_array(props_projectile)
	props.append_array(props_frag_projectiles)
	props.append_array(props_loader)
	props.append_array(props_weapon)
	
	return props
