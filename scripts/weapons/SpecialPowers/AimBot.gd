extends SpecialPower

@onready var area_effect = $Area2D
@onready var canvas = $CanvasLayer

@export var cursor_scene : PackedScene
@export var scale_cursor := Vector2(2, 2)
@export var canvas_enemy_offset := Vector2(30, 25)
@export var speed_aim_cursor : float = 20
@export var wait_time_between_shoots : float = 0.5

var enemy_list : Array[Enemy] = []
var cursor_list : Array[Cursor] = []
var is_shooting : bool = false

func specific_process(delta: float):
	var index : int = 0
	
	if enemy_list.size() == 0 and !is_shooting:
		_timer = 0
		end_power()
		return

	for enemy in enemy_list:
		if enemy == null:
			remove_target_in_arrays(index)
			index += 1
			continue
		smooth_clamp_cursor_position(cursor_list[index], enemy, delta)
		
		if !is_shooting and GlobalFunctions.is_inside_vector_2(cursor_list[index].global_position, enemy.get_global_transform_with_canvas().origin, canvas_enemy_offset):
			shoot_on_target(enemy)
			remove_target_in_arrays(index)
			await get_tree().create_timer(wait_time_between_shoots).timeout
			is_shooting = false
			
		index += 1

func remove_target_in_arrays(index: int):
	if cursor_list.size() > index:
		var cursor_instance = cursor_list[index]
		cursor_list.remove_at(index)
		cursor_instance.queue_free()
	enemy_list.remove_at(index)

func shoot_on_target(target: Node2D):
	if target != null:
		player.look_at(target.global_position)
		player_target = target.global_position
		is_shooting = true
		weapon.shoot()

func use_special_power():
	activated = true
	#print("use aim bot")
	
	var bodies = area_effect.get_overlapping_bodies()
	for body in bodies:
		if body == null:
			continue
		if body is Enemy:
			enemy_list.append(body as Enemy)
			spawn_cursor(body)

func spawn_cursor(body):
	var cursor_instance = cursor_scene.instantiate()
	cursor_list.append(cursor_instance as Cursor)
	canvas.add_child(cursor_instance)
	cursor_instance.scale = scale_cursor
	cursor_instance.active_mode_locked_gui()
	cursor_instance.global_position = self.get_global_transform_with_canvas().origin

func smooth_clamp_cursor_position(cursor: Cursor, body: Node2D, delta: float):
	var distance = (get_viewport_transform().affine_inverse() * cursor.global_position - body.global_position).length()
	var duration = distance / speed_aim_cursor
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(cursor, "global_position", body.get_global_transform_with_canvas().origin, duration)

func end_power():
	activated = false
	is_shooting = false
	player_target = Vector2.ZERO
	enemy_list = []
	for cursor in cursor_list:
		if cursor != null:
			cursor.queue_free()
	cursor_list = []
