extends Projectile
class_name ThrowedWeapon

# Interaction variables
@export var interaction_gui_texture : Texture
@export var interaction_name : String = ""
# ! Interaction variables

@export var should_spin : bool = true
@export var recover_weapon_interaction : AddWeaponInteraction = null

var time_stunning : float = 2


func _ready():
	if should_spin:
		animation_player.play("spining_sprite")


func set_projectile_type(weapon_type: ProjectileTypes.Type):
	projectile_type = weapon_type
	recover_weapon_interaction.weapon_type = weapon_type


func set_sprite(sprite: Sprite2D):
	if self.sprite == null:
		self.sprite = get_node("Sprite2D")
	self.sprite.texture = sprite.texture
	self.sprite.apply_scale(sprite.transform.get_scale())


func _process(delta):
	if !should_spin and animation_player != null and animation_player.is_playing():
		animation_player.stop()


func handle_specific_collision(object: Object):
	
	# get collision layer ?
	var collision = move_and_slide()
	if collision:
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMap:
			var tile_rid = get_last_slide_collision().get_collider_rid()
			var collision_layer = PhysicsServer2D.body_get_collision_layer(tile_rid)
			print("collision_layer = ", collision_layer)
			if collision_layer == 128:
				stop()
	
	if object.get_name() == "Walls" or object is ExplosiveBarrel:
		stop()
	
	if object.has_method("stunned"):
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
