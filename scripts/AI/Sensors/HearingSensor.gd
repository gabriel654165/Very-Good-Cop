extends Node2D
class_name HearingSensor

var eye_location: Vector2
@onready var _enemy: Enemy = $".."

signal sound_heard(source: Node2D, location: Vector2, intensity: float)

func _ready():
	if !GlobalSignals.sound_emitted.is_connected(_on_heard_sound):
		GlobalSignals.sound_emitted.connect(_on_heard_sound)

func _on_heard_sound(source: Node2D, location: Vector2, intensity: float):
	eye_location = global_position

	# outside of hearing range
	if location.distance_to(eye_location) > _enemy.hearing_range:
		return
	sound_heard.emit(source, location, intensity)
