@tool
extends Node2D
class_name VisionSensor

signal can_see_target(target: DetectableTarget)
signal lost_target(target: DetectableTarget)

var eye_location: Vector2
var eye_direction: Vector2
var cos_vision_cone_angle: float = 0
var space: PhysicsDirectSpaceState2D 
var current_target: DetectableTarget
@onready var _enemy: Enemy = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	cos_vision_cone_angle = cos(deg_to_rad(_enemy.vision_cone_angle));
	space = get_parent().get_world_2d().direct_space_state

func _process(delta):
	eye_location = global_position
	eye_direction = global_transform.x

	if Engine.is_editor_hint():
		queue_redraw()
		
	if not Engine.is_editor_hint():
		var temp_target: DetectableTarget = null
		for candidate_target in DetectableTargetManager.targets:
			var vector_to_target: Vector2 = candidate_target.get_parent().global_position - eye_location;

			# if out of range - cannot see
			if vector_to_target.length_squared() > _enemy.vision_cone_range * _enemy.vision_cone_range:
				continue

			var normalized_vector = vector_to_target.normalized();

			# if out of vision cone - cannot see
			if normalized_vector.dot(eye_direction) < cos_vision_cone_angle:
				continue
				
			# raycast to target passes?
			var param = PhysicsRayQueryParameters2D.create(eye_location, candidate_target.global_position, _enemy.vision_layers, [self, get_parent()])
			var hit_info = space.intersect_ray(param)
			if !hit_info.is_empty():
				if hit_info.collider.name == candidate_target.get_parent().name:
					temp_target = candidate_target

		if current_target != temp_target:
			if current_target != null:
				lost_target.emit(current_target)
			current_target = temp_target
			if current_target != null:
				can_see_target.emit(current_target)

func draw_circle_arc_poly(center: Vector2, radius: float, angle_from: float, angle_to: float, color: Color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func _draw():
	if not Engine.is_editor_hint():
		return
	_enemy = $".."	
	var center = global_transform.origin
	var radius = _enemy.vision_cone_range
	var color = Color(1.0, 0.0, 0.0, 0.4)
	draw_circle_arc_poly(Vector2.ZERO, radius, 0, _enemy.vision_cone_angle, color)
