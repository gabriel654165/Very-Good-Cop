extends Interaction
class_name PassiveEffect

var effect_name : String
var type : TYPE

var value_save : float
var value_effect : float = 10

var infinite_effect : bool = false
var effect_duration : float = 0

var sprite : Sprite2D
var used_sprite : Sprite2D

enum TYPE {
	HEALTH,
	SPEED,
	SLOW_MOTION,
	DAMAGE
}

func trigger(actor: Node):
	if actor == null || !(actor is Character):
		return
	#print("---Do passive effect action : ", self.name, " on : ", actor.name)
	#print("Values_effect updated ? : ", value_effect, " and type : ", type)
	add_passive_effect(actor)
	sprite.visible = false
	used_sprite.visible = true
	await get_tree().create_timer(effect_duration).timeout
	if actor != null:
		remove_passive_effect(actor)
	#print("effect removed")
	set_active(false)

func add_passive_effect(character: Character):
	if type == TYPE.HEALTH:
		character.health.heal(value_effect)
	if type == TYPE.SPEED:
		value_save = character.speed
		character.speed += value_effect
	if type == TYPE.DAMAGE:
		value_save = character.weapon_manager.bullet_damages
		character.weapon_manager.bullet_damages = value_effect
	
	if type == TYPE.SLOW_MOTION:
		pass
		#prendre tout les caractères et les slow down

func remove_passive_effect(character: Character):
	if type == TYPE.HEALTH:
		pass
	if type == TYPE.SPEED:
		character.speed = value_save
	if type == TYPE.DAMAGE:
		character.weapon_manager.bullet_damages = value_save
	
	if type == TYPE.SLOW_MOTION:
		pass
		#prendre tout les caractères et les slow down
