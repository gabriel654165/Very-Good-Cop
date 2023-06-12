extends Projectile
class_name ThrowedWeapon

@export var should_spin : bool = true
@export var recover_weapon_interaction : AddWeaponInteraction = null

var time_stunning : float = 2


func _ready():
	if should_spin:
		animation_player.play("spining_sprite")


func set_projectile_type(weapon_type: ProjectileTypes.Type):
	projectile_type = weapon_type
	recover_weapon_interaction.weapon_type = weapon_type


func _process(delta):
	if !should_spin and animation_player != null and animation_player.is_playing():
		animation_player.stop()


func handle_specific_collision(object: Object):
	if object.get_name() == "Walls":
		stop()
	
	if object.has_method("stunned"):
		print("object ", object.name, " stunned for x sec")
		object.stunned(time_stunning)
		stop()
	
	if object.has_method("handle_hit"):
		object.handle_hit(self, damages)
	
	if object.has_method("apply_force"):
		object.apply_force(object, self.direction, impact_force)


func stop():
	speed = 0
	direction = Vector2.ZERO
	if animation_player != null:
		animation_player.stop()
