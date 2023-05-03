extends StaticBody2D

@onready var health := $Health as Health
@onready var animation := $Animation as AnimationPlayer
@onready var particle_player := $ParticlePlayer as AnimationPlayer
@onready var explosion_area := $ExplosionArea as Area2D

@export var damage := 35.0
@export var impact_force := 20.0

func handle_hit(damager: Node2D, damage):
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

#	var explosion_particles_scene := preload("res://scenes/particles/Explosion.tscn")
#	var explosion_particle := explosion_particles_scene.instantiate()
#	add_child(explosion_particle)
#	explosion_particle.global_position = global_position

	var bodies := explosion_area.get_overlapping_bodies()

	for body in bodies:
		if body == null or body == self:
			continue
		if body.has_method("handle_hit"):
			body.handle_hit(self, damage)
		if body.has_method("apply_force"):
			var normalized_impact_direction = (body.global_position - self.global_position).normalized()
			print(body.name)
			print(normalized_impact_direction)
			print(impact_force)
			body.apply_force(body, normalized_impact_direction, impact_force)
		if body is Grenade:
			assert(body.has_method("explode"))
			body.explode()
