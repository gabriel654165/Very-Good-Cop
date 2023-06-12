extends Node
class_name InteractionManager

@export var is_active : bool = true

@export var interactions_nps: Array[NodePath]
@onready var interactions = interactions_nps.map(get_node)

@export var collision_interaction : CollisionInteraction = null

@export var next_interaction : Interaction = null

func set_active(new_state: bool):
	is_active = new_state
	if interactions == null:
		return
	#for child which are in interactions
	for child in self.get_children():
		if child is Interaction and interactions.has(child as Interaction):
			child.set_active(new_state)

func _process(delta):
	if !is_active:
		return
		
	var all_interactions_finished = true
	var body_touching : Node = null
	
	var common_data : Dictionary
	
	if collision_interaction != null:
		body_touching = collision_interaction.get_body_touching()

	for interaction in interactions:
		#print("interaction : ", interaction.name, " / is triggered : ", interaction.is_triggered)
		
		interaction.update_data(common_data)
		interaction.data = common_data
		
		if collision_interaction == null:
			all_interactions_finished = all_interactions_finished && interaction.is_triggered
		
		if collision_interaction != null and body_touching == null:
			all_interactions_finished = all_interactions_finished && interaction.is_triggered
		
		if interaction.for_who == Interaction.TRIGGER_ACTOR.EVERYBODY or character_to_trigger_actor(body_touching) == interaction.for_who:
			all_interactions_finished = all_interactions_finished && interaction.is_triggered
		else:
			all_interactions_finished = false

	if all_interactions_finished:
		action(body_touching)
		set_active(false)

func action(actor: Character = null):
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
