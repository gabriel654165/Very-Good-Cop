extends Projectile
class_name Grenade

@export var radius_pixels_impact_area : float = 100
@export var max_launch_distance : float = 400
@export var landing_precision : int = 1
@export var shader_animation : AnimationPlayer
@export var particle_animation : AnimationPlayer

@onready var explosion_timer = $ExplosionTimer
@onready var explosion_area = $ExplosionArea
@onready var explosion_area_shape = get_node("ExplosionArea/ExplosionCollisionShape2D")

var bodies = []
var distance : float = 0
var lauching_position := Vector2.ZERO
var landing_position := Vector2.ZERO

var explosition_sound : AudioStreamMP3


func _ready():
	randomize()
	scale = scale * size
	explosion_area_shape.get_shape().set_radius(radius_pixels_impact_area)
	explosition_sound = AudioStreamMP3.new()
	explosition_sound = load("res://assets/Sounds/explosion/barrel_explosion.mp3")
	hit_marker_sound = AudioStreamMP3.new()
	hit_marker_sound = load("res://assets/Sounds/impacts/hitmarker.mp3")

func _specific_process(delta):
	if speed == 0 or direction == Vector2.ZERO:
		return
	var range_safe := 5
	var distance_traveled := lauching_position.distance_to(global_position)
	if distance - range_safe <= distance_traveled and distance_traveled <= distance + range_safe:
		stop()

func handle_specific_collision(object: Object):
	if object is Enemy and projectile_owner is Player:
		GlobalSignals.play_sound.emit(hit_marker_sound, 0, 1, global_position)
	if object is Character:
		stop()
		explode()
		return

func stop():
	speed = 0
	direction = Vector2.ZERO
	explosion_timer.start()
	if animation_player != null:
		animation_player.stop()

func set_lauching_position(position: Vector2):
	self.lauching_position = position

func set_landing_position(landing_position: Vector2):
	self.landing_position = landing_position

func calulate_distance():
	distance = lauching_position.distance_to(landing_position)
	if distance > max_launch_distance:
		distance = max_launch_distance
	var range := randi() % landing_precision
	if randf()>0.5:
		range = -range
	distance += range

func explode():
	var pitch_scale:float =  explosition_sound.get_length() / 0.75
	
	GlobalSignals.play_sound.emit(explosition_sound, 0, pitch_scale, global_position)
	shader_animation.play("shockwave_shader_animation")
	particle_animation.play("grenade_explosion_particles")
	bodies = explosion_area.get_overlapping_bodies()
	for body in bodies:
		if body == null:
			continue
		if body.has_method("handle_hit"):
			body.handle_hit(self, damages)
		if body.has_method("apply_force"):
			var impact_direction = body.global_position - self.global_position
			body.apply_force(body, impact_direction, impact_force)
		#si c une grenade explose
		#if body is Grenade and body != self:
		#	body.explode()
	bodies = []

func _on_explosion_timer_timeout():
	explode()
