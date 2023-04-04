extends Node
class_name InteractionManager

@export var is_active : bool = true

@export var interactions_nps: Array[NodePath]
@onready var interactions = interactions_nps.map(get_node)

@export var collision_interaction : CollisionInteraction = null

@export var next_interaction_manager : InteractionManager = null

func _process(delta):
	if !is_active:
		return
		
	var all_interactions_finished = true
	var body_touching : Character = null
	
	if collision_interaction != null:
		body_touching = collision_interaction.get_body_touching()
	
	for interaction in interactions:
		var should_check_trigger = collision_interaction == null or interaction.for_who == Interaction.TRIGGER_ACTOR.EVERYBODY or character_to_trigger_actor(body_touching) == interaction.for_who
		
		if should_check_trigger and !interaction.is_triggered:
			all_interactions_finished = false
			break

	if all_interactions_finished:
		action(body_touching)
		set_active(false)

func set_active(new_state: bool):
	is_active = new_state
	
	#for child which are interaction
	for child in self.get_children():
		if child is Interaction and interactions.has(child as Interaction):
			child.set_active(new_state)

func action(actor: Character = null):
	print("---Do action : ", self.name)
	if next_interaction_manager != null:
		next_interaction_manager.set_active(true)

func character_to_trigger_actor(body: Character) -> Interaction.TRIGGER_ACTOR :
	var actor_type = Interaction.TRIGGER_ACTOR.NONE
	
	if body is Player:
		actor_type = Interaction.TRIGGER_ACTOR.PLAYER
	if body is Enemy:
		actor_type = Interaction.TRIGGER_ACTOR.ENEMY
	return actor_type
