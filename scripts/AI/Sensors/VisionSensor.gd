@tool
extends Node2D
class_name VisionSensor

@export var vision_cone_angle: float = 60
@export var vision_cone_range: float = 200
@export var _enemy: Enemy
@export_flags_2d_physics var layers_2d_physics

signal can_see_target(target: DetectableTarget)

var EyeLocation: Vector2
var EyeDirection: Vector2
var CosVisionConeAngle: float = 0
var space: PhysicsDirectSpaceState2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	CosVisionConeAngle = cos(deg_to_rad(vision_cone_angle));
	space = _enemy.get_world_2d().direct_space_state

func _physics_process(delta):
	EyeLocation = global_position
	EyeDirection = global_transform.x

	if Engine.is_editor_hint():
		queue_redraw()
		
	if not Engine.is_editor_hint():
		for candidateTarget in DetectableTargetManager.targets:
			var vectorToTarget: Vector2 = candidateTarget.get_parent().global_position - EyeLocation;

			# if out of range - cannot see
			if vectorToTarget.length_squared() > vision_cone_range * vision_cone_range:
				continue

			var normalized = vectorToTarget.normalized();

			# if out of vision cone - cannot see
			if normalized.dot(EyeDirection) < CosVisionConeAngle:
				continue
				
			# raycast to target passes?
			var param = PhysicsRayQueryParameters2D.create(EyeLocation, candidateTarget.global_position, 1, [self, _enemy])
			var hit_info = space.intersect_ray(param)
			if !hit_info.is_empty():
				print("Collider " + hit_info.collider.name)
				print("Candidate " + candidateTarget.get_parent().name)
				if hit_info.collider.name == candidateTarget.get_parent().name:
					can_see_target.emit(candidateTarget)

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
