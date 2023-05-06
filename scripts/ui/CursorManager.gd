extends Node2D
class_name CursorManager

@export var active : bool = false
@export var cursor_ui : PackedScene
@export var canvas_enemy_offset := Vector2(30, 25)
@export var cursor_offset := Vector2(11, 11)
@export var scale_sprite := Vector2(1, 1)
@export var auto_lock : bool = false
@export var auto_lock_offset : Vector2 = Vector2(55, 50)
@export var mouse_visible : bool = true

var enemy_list : Array[Enemy] = []
var cursor : Cursor

func _ready():
	if cursor_ui == null:
		active = false

func set_active(state: bool):
	if cursor_ui == null:
		return
	
	active = state
	if active:
		generate_ui()
	else:
		unload_ui()

func generate_ui():
	cursor = cursor_ui.instantiate()
	add_child(cursor)
	scale = scale_sprite
	if cursor != null:
		Input.set_custom_mouse_cursor(cursor.cursor_texture, Input.CURSOR_ARROW, cursor_offset)
	cursor.cursor_mode = DisplayServer.MOUSE_MODE_VISIBLE if mouse_visible else DisplayServer.MOUSE_MODE_HIDDEN
	DisplayServer.mouse_set_mode(cursor.cursor_mode)
	cursor.animator.play("cursor_idle")
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is Enemy, enemy_list, get_tree().root)

func unload_ui():
	pass

func _process(delta):
	if !active:
		return
	
	if !cursor.is_locked_gui:
		GlobalVariables.cursor_position = get_viewport().get_mouse_position() - cursor_offset
	var is_on_enemy_tmp = is_on_enemy()
	
	if auto_lock:
		var target = find_nearest_target()
		if target != Vector2.ZERO:
			smooth_clamp_cursor_position(target)
			if !cursor.is_locked_gui:
				cursor.active_mode_locked_gui()
		else:
			cursor.is_locked_gui = false
	
	if is_on_enemy_tmp and !cursor.is_attack_gui and !auto_lock and !cursor.is_menu_ui:
		cursor.active_mode_attack_gui()
	if !is_on_enemy_tmp and !cursor.is_idle_gui and !cursor.is_locked_gui and !cursor.is_menu_ui:
		cursor.active_mode_idle_gui()
	
	cursor.sprite.global_position = GlobalVariables.cursor_position

# Target are Enemy. Later Barrels will also be one.
func find_nearest_target() -> Vector2:
	var index : int = 0
	var target_pos := Vector2.ZERO
	
	while index < enemy_list.size():
		var enemy = enemy_list[index]
		
		if enemy == null:
			enemy_list.remove_at(index)
			index += 1
			continue
		var enemy_canvas_pos = enemy.get_global_transform_with_canvas().origin
		var mouse_pos = get_viewport().get_mouse_position()
		
		if GlobalFunctions.is_inside_vector_2(enemy_canvas_pos, mouse_pos, auto_lock_offset):
			var last_target_mouse_distance = (target_pos - mouse_pos).length()
			var new_target_mouse_distance = (enemy_canvas_pos - mouse_pos).length()
			if last_target_mouse_distance > new_target_mouse_distance:
				target_pos = enemy_canvas_pos
		
		index += 1
	return target_pos


func is_on_enemy() -> bool:
	var index : int = 0
	
	while index < enemy_list.size():
		var enemy = enemy_list[index]
		
		if enemy == null:
			enemy_list.remove_at(index)
			index += 1
			continue
		var enemy_canvas_pos = enemy.get_global_transform_with_canvas().origin
		var mouse_pos = get_viewport().get_mouse_position()
		
		if GlobalFunctions.is_inside_vector_2(enemy_canvas_pos, mouse_pos, canvas_enemy_offset):
			return true
		index += 1
	return false

func hit_marker_action():
	if cursor.is_attack_gui:
		cursor.active_mode_hit_marker_gui()

func _input(event):
#debug
	if event.is_action_pressed("change_cursor_type_test"):
		mouse_visible = !mouse_visible
		cursor.set_active_mouse(!mouse_visible)

func smooth_clamp_cursor_position(target: Vector2):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(GlobalVariables, "cursor_position", target, 0.1)
