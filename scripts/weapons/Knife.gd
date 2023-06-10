extends Area2D
class_name Knife

@export var weapon_name : String = ""
@export var points_to_use_special_power : int = 2
var current_points_to_use_special_power : int = 0
@export var can_use_power : bool = false
var power_activated : bool = false
@export var attack_cooldown : float = 1
@export var attack_distance : float = 30
@export var damages : float = 20
@export var can_throw : bool = false

@onready var side_sprite = $SideSprite2D
@onready var attack_cooldown_timer = $AttackCoolDown
@onready var collision_shape = $CollisionShape2D

var stab_actor : Node = null
var close_fight_bodies = []
var enable : bool = true


func _ready():
	stab_actor = get_parent()
	update_properties()


func stab():
	if !enable:
		return
	
	if attack_cooldown_timer.is_stopped():
		attack_cooldown_timer.start()
		
		GlobalSignals.weapon_stab.emit(stab_actor)
		
		if close_fight_bodies.size() <= 0:
			return
	
		#le plus proche ?
		#celui dans ta direction
		# -> réduire la range (un quart de cercle) en face du player
		for body in close_fight_bodies:
			if body.has_method("handle_hit"):
				body.handle_hit(self, damages)
				break
	

func update_properties():
	attack_cooldown_timer.wait_time = attack_cooldown
	collision_shape.shape.radius = attack_distance


func _on_body_entered(new_body):
	if self.get_parent() == new_body:
		return
	#print("new_body = ", new_body)
	if new_body is Character:
		close_fight_bodies.append(new_body)


func _on_body_exited(new_body):
	var index : int = 0
	for body in close_fight_bodies:
		if body == new_body:
			close_fight_bodies.remove_at(index)
		index += 1
