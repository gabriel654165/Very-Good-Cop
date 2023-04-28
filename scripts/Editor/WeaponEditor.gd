@tool
extends Node2D

var weapon : Node

var weapon_name : String
var special_power_unlocked : bool = false
var level : int = 0

var points_to_unlock_power : int = 200
var current_points_charge_power : int = 0
var can_use_power : bool = false

var projectile_scene : PackedScene
var bullet_speed : int = 4
var bullet_damages : int = 6
var bullet_size : float = 0.5
var bullet_impact_force : float = 2
var bullet_piercing_force : int = 0
var bullet_should_bounce : bool = false
var bullet_should_pierce_walls : bool = false

var loader_capacity : int = 6

var enable : bool = true
var number_of_balls_by_burt : int = 1
var frequence_of_burt : float = 0.1
var precision_angle : Vector2 = Vector2(-1, 1)
var precision : float = 0
var recoil_force : float = 2

func _ready():
	weapon = self.get_child(0) as Weapon
	if weapon == null:
		return
	set_variables(weapon)

#func _process(delta):
#	if not Engine.is_editor_hint():
#		set_variables(weapon)

func set_pos(position):
	weapon.global_position = position

func set_projectile(new_projectile: PackedScene):
	self.Projectile = new_projectile
	weapon.Projectile = new_projectile

func set_variables(new_weapon: Weapon, upadte_projectile: bool = true, update_nodes: bool = true):
	if weapon == null:
		weapon = new_weapon
	
	weapon.weapon_name = self.weapon_name
	weapon.special_power_unlocked = self.special_power_unlocked
	weapon.level = self.level
	
	weapon.points_to_unlock_power = self.points_to_unlock_power
	weapon.current_points_charge_power = self.current_points_charge_power
	weapon.can_use_power = self.can_use_power
	
	if upadte_projectile:
		weapon.projectile_scene = self.projectile_scene
	weapon.bullet_speed = self.bullet_speed
	weapon.bullet_damages = self.bullet_damages
	weapon.bullet_size = self.bullet_size
	weapon.bullet_impact_force = self.bullet_impact_force
	weapon.bullet_piercing_force = self.bullet_piercing_force
	weapon.bullet_should_bounce = self.bullet_should_bounce
	weapon.bullet_should_pierce_walls = self.bullet_should_pierce_walls
	
	weapon.loader_capacity = self.loader_capacity
	
	weapon.enable = self.enable
	weapon.number_of_balls_by_burt = self.number_of_balls_by_burt
	weapon.frequence_of_burt = self.frequence_of_burt
	weapon.precision_angle = self.precision_angle
	weapon.precision = self.precision
	weapon.recoil_force = self.recoil_force

func _get(property):
	if property == 'properties/weapon_name':
		return weapon_name
	if property == 'properties/special_power_unlocked':
		return special_power_unlocked
	if property == 'properties/level':
		return level
	
	if property == 'power/points_to_unlock_power':
		return points_to_unlock_power
	if property == 'power/current_points_charge_power':
		return current_points_charge_power
	if property == 'power/can_use_power':
		return can_use_power
	
	if property == 'bullet/projectile':
		return projectile_scene
	if property == 'bullet/bullet_speed':
		return bullet_speed
	if property == 'bullet/bullet_damages':
		return bullet_damages
	if property == 'bullet/bullet_size':
		return bullet_size
	if property == 'bullet/bullet_impact_force':
		return bullet_impact_force
	if property == 'bullet/bullet_piercing_force':
		return bullet_piercing_force
	if property == 'bullet/bullet_should_bounce':
		return bullet_should_bounce
	if property == 'bullet/bullet_should_pierce_walls':
		return bullet_should_pierce_walls
	
	if property == 'loader/loader_capacity':
		return loader_capacity
	
	if property == 'weapon/enable':
		return enable
	if property == 'weapon/number_of_balls_by_burt':
		return number_of_balls_by_burt
	if property == 'weapon/frequence_of_burt':
		return frequence_of_burt
	if property == 'weapon/precision_angle':
		return precision_angle
	if property == 'weapon/precision':
		return precision
	if property == 'weapon/recoil_force':
		return recoil_force

func _set(property, value) -> bool :
	if property == 'properties/weapon_name':
		weapon_name = value
	if property == 'properties/special_power_unlocked':
		special_power_unlocked = value
	if property == 'properties/level':
		level = value
	
	if property == 'power/points_to_unlock_power':
		points_to_unlock_power = value
	if property == 'power/current_points_charge_power':
		current_points_charge_power = value
	if property == 'power/can_use_power':
		can_use_power = value
	
	if property == 'bullet/projectile':
		projectile_scene = value
	if property == 'bullet/bullet_speed':
		bullet_speed = value
	if property == 'bullet/bullet_damages':
		bullet_damages = value
	if property == 'bullet/bullet_size':
		bullet_size = value
	if property == 'bullet/bullet_impact_force':
		bullet_impact_force = value
	if property == 'bullet/bullet_piercing_force':
		bullet_piercing_force = value
	if property == 'bullet/bullet_should_bounce':
		bullet_should_bounce = value
	if property == 'bullet/bullet_should_pierce_walls':
		bullet_should_pierce_walls = value
	
	if property == 'loader/loader_capacity':
		loader_capacity = value
	
	if property == 'weapon/enable':
		enable = value
	if property == 'weapon/number_of_balls_by_burt':
		number_of_balls_by_burt = value
	if property == 'weapon/frequence_of_burt':
		frequence_of_burt = value
	if property == 'weapon/precision_angle':
		precision_angle = value
	if property == 'weapon/precision':
		precision = value
	if property == 'weapon/recoil_force':
		recoil_force = value
	return true

func _get_property_list() -> Array:
	var props = []
	props.append_array(
	[{
		'name': 'properties/weapon_name',
		'type': TYPE_STRING,
	},{
		'name': 'properties/special_power_unlocked',
		'type': TYPE_BOOL,
	},{
		'name': 'properties/level',
		'type': TYPE_INT,
	},{
		'name': 'power/points_to_unlock_power',
		'type': TYPE_INT,
	},{
		'name': 'power/current_points_charge_power',
		'type': TYPE_INT,
	},{
		'name': 'power/can_use_power',
		'type': TYPE_BOOL,
	},{
		'name': 'bullet/projectile',
		'type': TYPE_OBJECT,
	},{
		'name': 'bullet/bullet_speed',
		'type': TYPE_INT,
	},{
		'name': 'bullet/bullet_damages',
		'type': TYPE_INT,
	},{
		'name': 'bullet/bullet_size',
		'type': TYPE_FLOAT,
	},{
		'name': 'bullet/bullet_impact_force',
		'type': TYPE_FLOAT,
	},{
		'name': 'bullet/bullet_piercing_force',
		'type': TYPE_INT,
	},{
		'name': 'bullet/bullet_should_bounce',
		'type': TYPE_BOOL,
	},{
		'name': 'bullet/bullet_should_pierce_walls',
		'type': TYPE_BOOL,
	},{
		'name': 'loader/loader_capacity',
		'type': TYPE_INT,
	},{
		'name': 'weapon/enable',
		'type': TYPE_BOOL,
	},{
		'name': 'weapon/number_of_balls_by_burt',
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
	},
	])
	return props
