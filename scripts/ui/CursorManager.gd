extends Node2D

@export var cursor_ui : PackedScene
@export var canvas_enemy_offset := Vector2(30, 25)
@export var cursor_offset := Vector2(6, 6)
@export var scale_sprite := Vector2(1, 1)

var is_attack_gui : bool = false
var is_idle_gui : bool = true
var is_menu_ui : bool = false

var enemy_list : Array[Enemy] = []
var cursor_animator : AnimationPlayer = null
var cursor_sprite : Sprite2D = null
#var cursor : Sprite2D = $BasicCursorSprite
var cursor = load("res://assets/UI/Cursors/sprCursor.png")

func _ready():
	if cursor_ui == null:
		return
	var cursor_ui_instance = cursor_ui.instantiate()
	add_child(cursor_ui_instance)
	
	scale = scale_sprite
	cursor_animator = cursor_ui_instance.get_node("AnimationPlayer") as AnimationPlayer
	cursor_sprite = cursor_ui_instance.get_node("Sprite2D") as Sprite2D
	if cursor != null:
		Input.set_custom_mouse_cursor(cursor)
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	cursor_animator.play("cursor_idle")
	GlobalFunctions.append_in_array_on_condition(func(elem: Node): return elem is Enemy, enemy_list, get_tree().root)

func _process(delta):
	cursor_sprite.global_position = get_viewport().get_mouse_position() + cursor_offset
	
	var is_on_enemy_tmp = is_on_enemy()
	if is_on_enemy_tmp and !is_attack_gui:
		active_mode_attack_gui()
	if !is_on_enemy_tmp and !is_idle_gui:
		active_mode_idle_gui()

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

#ui activation
func active_mode_idle_gui():
	is_idle_gui = true
	is_menu_ui = false
	is_attack_gui = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	cursor_animator.play("cursor_idle")

func active_mode_hit_marker_gui():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	cursor_animator.play("cursor_hit_marker")

func active_mode_attack_gui():
	is_attack_gui = true
	is_menu_ui = false
	is_idle_gui = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	cursor_animator.play("cursor_on_enemy")

func active_mode_ui():
	is_menu_ui = true
	is_attack_gui = false
	is_idle_gui = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _input(event):
	#if event.is_action_pressed("shoot"):
	#	active_mode_hit_marker_gui()
#debug
	if event.is_action_pressed("test2"):
		set_active_mouse()

func set_active_mouse():
	if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_HIDDEN:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	else:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
