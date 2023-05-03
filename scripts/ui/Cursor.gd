extends Node2D
class_name Cursor

var cursor_animator : AnimationPlayer = null
var cursor_sprite : Sprite2D = null

var is_attack_gui : bool = false
var is_idle_gui : bool = true
var is_menu_ui : bool = false
var is_locked_gui : bool = false

var cursor_mode := DisplayServer.MOUSE_MODE_HIDDEN
var cursor_texture = load("res://assets/UI/Cursors/sprCursor.png")

@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer

func active_mode_idle_gui():
	is_idle_gui = true
	is_menu_ui = false
	is_attack_gui = false
	is_locked_gui = false
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_idle")

func active_mode_hit_marker_gui():
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_hit_marker")

func active_mode_attack_gui():
	is_attack_gui = true
	is_menu_ui = false
	is_idle_gui = false
	is_locked_gui = false
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_on_enemy")

func active_mode_locked_gui():
	is_locked_gui = true
	is_attack_gui = false
	is_menu_ui = false
	is_idle_gui = false
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_locked")

func active_mode_ui():
	set_active_mouse(true)
	is_menu_ui = true
	is_attack_gui = false
	is_idle_gui = false
	is_locked_gui = false
	DisplayServer.mouse_set_mode(cursor_mode)

func set_active_mouse(state: bool):
	if state:
		cursor_mode = DisplayServer.MOUSE_MODE_VISIBLE
		DisplayServer.mouse_set_mode(cursor_mode)
	else:
		cursor_mode = DisplayServer.MOUSE_MODE_HIDDEN
		DisplayServer.mouse_set_mode(cursor_mode)
