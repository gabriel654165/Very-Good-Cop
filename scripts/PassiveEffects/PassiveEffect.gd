extends Node
class_name PassiveEffect

#@onready var effect_duration = $EffectDuration as Timer

@export var effect_name : String
@export var Type : TYPE

@export var value_effect : float = 10

@export var infinite_effect : bool = false
@export var effect_duration : float = 0

enum TYPE {
	HEALTH,
	SPEED,
	SLOW_MOTION,
	DAMAGE
}

func _ready():
	pass

func _process(delta):
	pass

func add_passive_effect(character: Character):
	if Type == TYPE.HEALTH:
		character.health.heal(value_effect)
	if Type == TYPE.SPEED:
		character.speed.
	await get_tree().create_timer(effect_duration).timeout
	remove_passive_effect(character)
	pass

func remove_passive_effect(character: Character):
	pass
