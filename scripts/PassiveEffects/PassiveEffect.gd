extends InteractionManager
class_name PassiveEffect

@export var effect_name : String
@export var Type : TYPE

var value_save : float
@export var value_effect : float = 10

@export var infinite_effect : bool = false
@export var effect_duration : float = 0

enum TYPE {
	HEALTH,
	SPEED,
	SLOW_MOTION,
	DAMAGE
}

#Idée : 
# les interactions on un action() qui les actives ou les run
# et le passiveEffect est une interaction



# appeler une Interaction après qu'un InteractionManager a été compute c plus logique



#Question / Idée : 
# est ce que : Interaction -> InteractionProcessor
# ou : InteractionProcessor -> Interaction

# collision_interaction is InteractionManager
	# spam_interaction is InteractionManager
	# passive_effect extends InteractionManager
	
	#InteractionManager - Collision_interaction : 
	# tiggers : col + [E]
	# -> spam_interaction->set_active(true)
	
	#InteractionManager - Spam_interaction :
	# triggers : col + [mouse-click] X times || wait X time
	# -> passive_effec->set_active(true)
	
	#InteractionManager
	#Passive_effec :
	# action() add_power_up()
	
	# MAIS il faut que ce soit le même actor qui collide et qui fait les autres actions

func action(actor: Character = null):
	if actor == null:
		return
	print("---Do passive effect action : ", self.name, " on : ", actor.name)
	add_passive_effect(actor)

func add_passive_effect(character: Character):
	if Type == TYPE.HEALTH:
		character.health.heal(value_effect)
	if Type == TYPE.SPEED:
		value_save = character.speed
		character.speed += value_effect
	if Type == TYPE.DAMAGE:
		value_save = character.weapon_manager.bullet_damages
		character.weapon_manager.bullet_damages = value_effect
	
	if Type == TYPE.SLOW_MOTION:
		pass
		#prendre tout les caractères et les slow down
	
	await get_tree().create_timer(effect_duration).timeout
	remove_passive_effect(character)

func remove_passive_effect(character: Character):
	if Type == TYPE.HEALTH:
		pass
	if Type == TYPE.SPEED:
		character.speed = value_save
	if Type == TYPE.DAMAGE:
		character.weapon_manager.bullet_damages = value_save
	
	if Type == TYPE.SLOW_MOTION:
		pass
		#prendre tout les caractères et les slow down
