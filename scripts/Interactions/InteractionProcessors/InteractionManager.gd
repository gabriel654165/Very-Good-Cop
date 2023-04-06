extends Node
class_name InteractionManager

@export var is_active : bool = true

@export var interactions_nps: Array[NodePath]
@onready var interactions = interactions_nps.map(get_node)

@export var collision_interaction : CollisionInteraction = null

@export var next_interaction : Interaction = null

func set_active(new_state: bool):
	is_active = new_state
	#for child which are in interactions
	for child in self.get_children():
		if child is Interaction and interactions.has(child as Interaction):
			child.set_active(new_state)

func _process(delta):
	if !is_active:
		return
		
	var all_interactions_finished = true
	var body_touching : Node = null
	
	if collision_interaction != null:
		body_touching = collision_interaction.get_body_touching()
	
	for interaction in interactions:
		#por avoir des events differents si tu est enemy, player, bullet, etc
		
		#instead of &= : 
		#boolean1 = boolean1 && boolean2
		
		var should_check_trigger = collision_interaction == null or interaction.for_who == Interaction.TRIGGER_ACTOR.EVERYBODY or character_to_trigger_actor(body_touching) == interaction.for_who
		
		if should_check_trigger and !interaction.is_triggered:
			all_interactions_finished = false
			break

	if all_interactions_finished:
		action(body_touching)
		set_active(false)

func action(actor: Character = null):
	print("---Do action : ", self.name)
	if next_interaction != null:
		next_interaction.set_active(true)
		next_interaction.trigger(actor)

func character_to_trigger_actor(body: Node) -> Interaction.TRIGGER_ACTOR :
	var actor_type = Interaction.TRIGGER_ACTOR.NONE
	
	if body is Player:
		actor_type = Interaction.TRIGGER_ACTOR.PLAYER
	if body is Enemy:
		actor_type = Interaction.TRIGGER_ACTOR.ENEMY
	return actor_type
