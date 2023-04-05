@tool
extends Node2D

var passive_effect : Node

var effect_name : String
var type : PassiveEffect.TYPE

var value_effect : float = 10

var infinite_effect : bool = false
var effect_duration : float = 0

func _ready():
	passive_effect = get_child(2) as PassiveEffect
	if passive_effect == null:
		return
	set_variables(passive_effect)

func set_variables(new_passive_effect: PassiveEffect):
	if passive_effect == null:
		passive_effect = new_passive_effect
	
	passive_effect.effect_name = self.effect_name
	passive_effect.type = self.type
	passive_effect.value_effect = self.value_effect
	passive_effect.infinite_effect = self.infinite_effect
	passive_effect.effect_duration = self.effect_duration

func _process(delta):
	if not Engine.is_editor_hint():
		set_variables(passive_effect)

func _get(property):
	if property == 'effect_name':
		return effect_name
	if property == 'type':
		return type
	if property == 'value_effect':
		return value_effect
	if property == 'infinite_effect':
		return infinite_effect
	if property == 'effect_duration':
		return effect_duration

func _set(property, value) -> bool :
	if property == 'effect_name':
		effect_name = value
	if property == 'type':
		type = value
	if property == 'value_effect':
		value_effect = value
	if property == 'infinite_effect':
		infinite_effect = value
	if property == 'effect_duration':
		effect_duration = value
	return true

func _get_property_list() -> Array:
	var props = []
	props.append_array(
	[{
		'name': 'effect_name',
		'type': TYPE_STRING,
	},{
		"hint": PROPERTY_HINT_ENUM,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "type",
		"type": TYPE_INT,
		"hint_string": PackedStringArray(PassiveEffect.TYPE.keys()),#.join(","),
		#"hint_string": PackedStringArray([PassiveEffect.TYPE.HEALTH, PassiveEffect.TYPE.SPEED]),
		#"hint_string": Array[PassiveEffect.TYPE],
		#"hint_string": Array(PassiveEffect.TYPE.keys()),#.join(","),
		#"hint_string": PackedStringArray(PassiveEffect.TYPE.keys()),#.join(","),
	},{
		'name': 'value_effect',
		'type': TYPE_FLOAT,
	},{
		'name': 'infinite_effect',
		'type': TYPE_BOOL,
	},{
		'name': 'effect_duration',
		'type': TYPE_FLOAT,
	}
	])
	return props
