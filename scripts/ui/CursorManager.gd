extends Node2D

@export var canvas_enemy_offset := Vector2(30, 25)
@export var cursor_offset := Vector2(6, 6)
@export var scale_sprite := Vector2(1, 1)

#var cursor : Sprite2D = $BasicCursorSprite
@onready var cursor_animator = $AnimationPlayer
@onready var cursor_sprite = $Sprite2D

var is_attack_gui : bool = false
var is_idle_gui : bool = true
var is_menu_ui : bool = false

var enemy_list : Array[Enemy] = []
var cursor = load("res://assets/UI/Cursors/sprCursor.png")

func _ready():
	#si la souris existe faire spawn le cursor
	scale = scale_sprite
	if cursor != null:
		Input.set_custom_mouse_cursor(cursor)
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	cursor_animator.play("cursor_idle")
	append_enemy_object_from_all_child_nodes(get_tree().root)

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

func append_enemy_object_from_all_child_nodes(parent: Node):
	for child in parent.get_children():
		if child is Enemy:
			enemy_list.append(child)
		if child.get_child_count() > 0:
			append_enemy_object_from_all_child_nodes(child)

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
	if event.is_action_pressed("shoot"):
		active_mode_hit_marker_gui()
#debug
	if event.is_action_pressed("test2"):
		set_active_mouse()

func set_active_mouse():
	if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_HIDDEN:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	else:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
