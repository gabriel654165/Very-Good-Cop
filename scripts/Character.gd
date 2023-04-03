extends CharacterBody2D
class_name Character

@onready var health = $Health as Health
@onready var weapon_position = $WeaponPosition

@export var speed : float = 6
var force : Vector2 = Vector2.ZERO

var has_weapon : bool = true
@export var weapon_manager : Node2D = null

var has_knife : bool = true
@export var knife : Knife = null

var has_grappling_hook : bool = true
@export var grappling_hook : Node2D = null

@export var passive_effect_list : Dictionary

#var has_bulletproof_vest : bool = true
#var bulletproof_vest : Node2D = null

#func _ready():
#	GlobalSignals.connect("bullet_fired_force", Callable(self, "apply_force"))

func apply_force(character: Character, direction: Vector2, force: float):
	character.force = direction * force

