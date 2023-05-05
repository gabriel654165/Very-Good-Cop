extends StaticBody2D

@onready var health := $Health as Health
@onready var animation := $Explosion/Animation as AnimationPlayer
@onready var particle_player := $ExplosionParticle/Animation as AnimationPlayer
@onready var explosion_area := $ExplosionArea as Area2D

@export var damage := 35.0
@export var impact_force := 20.0

func handle_hit(damager: Node2D, damage):
	if health.is_dead():
		return

	if damager is Bullet:
		damage = 1
	health.hit(damage)
	if health.is_dead():
		explode()

func destroy_instance():
	queue_free()

func explode():
	animation.play("explosion")

	particle_player.play("explosion_praticle")

	var bodies := explosion_area.get_overlapping_bodies()

	for body in bodies:
		if body == null or body == self:
			continue
		if body.has_method("handle_hit"):
			body.handle_hit(self, damage)
		if body.has_method("apply_force"):
			var normalized_impact_direction = (body.global_position - self.global_position).normalized()
			body.apply_force(body, normalized_impact_direction, impact_force)
		if body is Grenade:
			assert(body.has_method("explode"))
			body.explode()
