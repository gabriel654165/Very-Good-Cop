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
	HEAL,
	SPEED,
	SLOW_MOTION,
	DAMAGE,
	MINIMAP_EXTEND
}


func trigger(actor: Node):
	if actor == null || !(actor is Character):
		return
	add_passive_effect(actor)
	sprite.visible = false
	used_sprite.visible = true
	await get_tree().create_timer(effect_duration).timeout
	if actor != null:
		remove_passive_effect(actor)
	set_active(false)


func add_passive_effect(character: Character):
	GlobalSignals.power_up_taken.emit(self)
	
	if type == TYPE.HEAL:
		character.health.heal(value_effect)
		GlobalSignals.active_heal_power_up.emit(true)
	if type == TYPE.SPEED:
		value_save = character.speed
		character.speed += value_effect
		GlobalSignals.active_speed_power_up.emit(true)
	if type == TYPE.DAMAGE:
		value_save = character.weapon_manager.projectile_damages
		character.weapon_manager.projectile_damages = value_effect
		character.weapon_manager.weapon.projectile_damages = value_effect
		character.weapon_manager.set_variables(character.weapon_manager.weapon)
		GlobalSignals.active_damage_power_up.emit(true)
	if type == TYPE.SLOW_MOTION:
		Engine.time_scale = 0.4
		GlobalSignals.active_slowmotion_power_up.emit(true)
	if type == TYPE.MINIMAP_EXTEND:
		GlobalSignals.active_minimap_power_up.emit(true)


func remove_passive_effect(character: Character):
	if type == TYPE.SPEED:
		character.speed = value_save
		GlobalSignals.active_speed_power_up.emit(false)
	if type == TYPE.DAMAGE:
		character.weapon_manager.projectile_damages = value_save
		character.weapon_manager.weapon.projectile_damages = value_save
		character.weapon_manager.set_variables(character.weapon_manager.weapon)
		GlobalSignals.active_damage_power_up.emit(false)
	if type == TYPE.SLOW_MOTION:
		Engine.time_scale = 1
		GlobalSignals.active_slowmotion_power_up.emit(false)
	if type == TYPE.MINIMAP_EXTEND:
		GlobalSignals.active_minimap_power_up.emit(false)
