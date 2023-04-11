@tool
extends Node2D

var weapon : Node

var Projectile : PackedScene

var loader_capacity : int = 6
var bullet_speed : float = 4
var bullet_damages : int = 6
var bullet_size : int = 0.5
var bullet_impact_force : int = 2

var number_of_balls_by_burt : int = 1
var frequence_of_burt : float = 0.1
var precision_angle : Vector2 = Vector2(-1, 1)
var precision : float = 0
var recoil_force : float = 2

var fire_position : NodePath
var fire_direction : NodePath
var attack_cooldown : NodePath
var reload_cooldown : NodePath
var animation : NodePath
var sprite : NodePath
var side_sprite : NodePath

func _ready():
	weapon = self.get_child(0) as Weapon
	if weapon == null:
		return
	set_variables(weapon)

func _process(delta):
	if not Engine.is_editor_hint():
		set_variables(weapon)

func set_pos(position):
	weapon.global_position = position

func set_projectile(new_projectile: PackedScene):
	self.Projectile = new_projectile
	weapon.Projectile = new_projectile

func set_variables(new_weapon: Weapon, upadte_projectile: bool = true, update_nodes: bool = true):
	if weapon == null:
		weapon = new_weapon
	
	if upadte_projectile:
		weapon.Projectile = self.Projectile
	
	weapon.loader_capacity = self.loader_capacity
	weapon.bullet_speed = self.bullet_speed
	weapon.bullet_damages = self.bullet_damages
	weapon.bullet_size = self.bullet_size
	weapon.bullet_impact_force = self.bullet_impact_force
	
	weapon.number_of_balls_by_burt = self.number_of_balls_by_burt
	weapon.frequence_of_burt = self.frequence_of_burt
	weapon.precision_angle = self.precision_angle
	weapon.precision = self.precision
	weapon.recoil_force = self.recoil_force
	
	if update_nodes:
		weapon.fire_position = self.get_node(self.fire_position) as Marker2D
		weapon.fire_direction = self.get_node(self.fire_direction) as Marker2D
		weapon.attack_cooldown = self.get_node(self.attack_cooldown) as Timer
		weapon.reload_cooldown = self.get_node(self.reload_cooldown) as Timer
		weapon.animation = self.get_node(self.animation) as AnimationPlayer
		weapon.sprite = self.get_node(self.sprite) as Sprite2D
		weapon.side_sprite = self.get_node(self.side_sprite) as Sprite2D

func _get(property):
	if property == 'bullet/Projectile':
		return Projectile
	
	if property == 'loader/loader_capacity':
		return loader_capacity
	
	if property == 'bullet/bullet_speed':
		return bullet_speed
	if property == 'bullet/bullet_damages':
		return bullet_damages
	if property == 'bullet/bullet_size':
		return bullet_size
	if property == 'bullet/bullet_impact_force':
		return bullet_impact_force
	
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
	
	if property == 'objects/fire_position':
		return fire_position
	if property == 'objects/fire_direction':
		return fire_direction
	if property == 'objects/attack_cooldown':
		return attack_cooldown
	if property == 'objects/reload_cooldown':
		return reload_cooldown
	if property == 'objects/animation':
		return animation
	if property == 'objects/sprite':
		return sprite
	if property == 'objects/side_sprite':
		return side_sprite

func _set(property, value) -> bool :
	if property == 'bullet/Projectile':
		Projectile = value
	
	if property == 'loader/loader_capacity':
		loader_capacity = value
	
	if property == 'bullet/bullet_speed':
		bullet_speed = value
	if property == 'bullet/bullet_damages':
		bullet_damages = value
	if property == 'bullet/bullet_size':
		bullet_size = value
	if property == 'bullet/bullet_impact_force':
		bullet_impact_force = value
	
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
	
	if property == 'objects/fire_position':
		fire_position = value
	if property == 'objects/fire_direction':
		fire_direction = value
	if property == 'objects/attack_cooldown':
		attack_cooldown = value
	if property == 'objects/reload_cooldown':
		reload_cooldown = value
	if property == 'objects/animation':
		animation = value
	if property == 'objects/sprite':
		sprite = value
	if property == 'objects/side_sprite':
		side_sprite = value
	return true

func _get_property_list() -> Array:
	var props = []
	props.append_array(
	[{
		'name': 'bullet/Projectile',
		'type': TYPE_OBJECT,
	},{
		'name': 'loader/loader_capacity',
		'type': TYPE_INT,
	},{
		'name': 'bullet/bullet_speed',
		'type': TYPE_FLOAT,
	},{
		'name': 'bullet/bullet_damages',
		'type': TYPE_INT,
	},{
		'name': 'bullet/bullet_size',
		'type': TYPE_INT,
	},{
		'name': 'bullet/bullet_impact_force',
		'type': TYPE_INT,
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
	},{
		name="objects/fire_position",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},{
		name= "objects/fire_direction",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},{
		name= "objects/attack_cooldown",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},{
		name= "objects/reload_cooldown",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},{
		name= "objects/animation",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},{
		name= "objects/sprite",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},{
		name= "objects/side_sprite",
		type=TYPE_NODE_PATH,
		usage=PROPERTY_USAGE_DEFAULT,
		hint=35,
		hint_string="Node",
	},
	])
	return props
