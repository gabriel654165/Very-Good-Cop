extends Interaction
class_name AddWeaponInteraction

@export var weapon_type : ProjectileTypes.Type = ProjectileTypes.Type.PROJECTILE_WEAPON

func trigger(actor: Node):
	if !(actor is Player):
		return
	actor.recover_weapon(weapon_type)
	get_owner().queue_free()
