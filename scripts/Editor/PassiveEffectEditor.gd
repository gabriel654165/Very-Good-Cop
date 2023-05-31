@tool
extends Node2D

var passive_effect : PassiveEffect

var effect_name : String
var type : PassiveEffect.TYPE

var value_effect : float = 10

var infinite_effect : bool = false
var effect_duration : float = 0

var sprite : NodePath
var used_sprite : NodePath

func _ready():
	#todo : get child of type PassiveEffect instead
	passive_effect = get_child(3) as PassiveEffect
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
	
	passive_effect.sprite = self.get_node(self.sprite) as Sprite2D
	passive_effect.used_sprite = self.get_node(self.used_sprite) as Sprite2D

func _process(delta):
	if not Engine.is_editor_hint():
		set_variables(passive_effect)

func _get(property):
	if property == 'global_position':
		return global_position
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
	if property == 'sprite':
		return sprite
	if property == 'used_sprite':
		return used_sprite

func _set(property, value) -> bool :
	if property == 'global_position':
		global_position = value
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
	if property == 'sprite':
		sprite = value
	if property == 'used_sprite':
		used_sprite = value
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
	},{
		'name': 'sprite',
		'type': TYPE_NODE_PATH,
		'usage': PROPERTY_USAGE_DEFAULT,
		'hint': 35,
		'hint_string': "Node",
	},{
		'name': 'used_sprite',
		'type': TYPE_NODE_PATH,
		'usage': PROPERTY_USAGE_DEFAULT,
		'hint': 35,
		'hint_string': "Node",
	}
	])
	return props
