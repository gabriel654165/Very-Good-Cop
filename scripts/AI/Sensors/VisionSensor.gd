@tool
extends Node2D
class_name VisionSensor

@export var vision_cone_angle: float = 60
@export var vision_cone_range: float = 200
@export_flags_2d_physics var layers_2d_physics

signal can_see_target(target: DetectableTarget)
signal lost_target(target: DetectableTarget)

var EyeLocation: Vector2
var EyeDirection: Vector2
var CosVisionConeAngle: float = 0
var space: PhysicsDirectSpaceState2D 
var current_target: DetectableTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	CosVisionConeAngle = cos(deg_to_rad(vision_cone_angle));
	space = get_parent().get_world_2d().direct_space_state

func _process(delta):
	EyeLocation = global_position
	EyeDirection = global_transform.x

	if Engine.is_editor_hint():
		queue_redraw()
		
	if not Engine.is_editor_hint():
		var temp_target: DetectableTarget = null
		for candidate_target in DetectableTargetManager.targets:
			var vector_to_target: Vector2 = candidate_target.get_parent().global_position - EyeLocation;

			# if out of range - cannot see
			if vector_to_target.length_squared() > vision_cone_range * vision_cone_range:
				continue

			var normalized_vector = vector_to_target.normalized();

			# if out of vision cone - cannot see
			if normalized_vector.dot(EyeDirection) < CosVisionConeAngle:
				continue
				
			# raycast to target passes?
			var param = PhysicsRayQueryParameters2D.create(EyeLocation, candidate_target.global_position, 1, [self, get_parent()])
			var hit_info = space.intersect_ray(param)
			if !hit_info.is_empty():
				if hit_info.collider.name == candidate_target.get_parent().name:
					temp_target = candidate_target
		if current_target != temp_target:
			if  current_target != null:
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
	var center = global_transform.origin
	var radius = vision_cone_range
	var color = Color(1.0, 0.0, 0.0, 0.4)
	draw_circle_arc_poly(Vector2.ZERO, radius, 0, vision_cone_angle, color)
