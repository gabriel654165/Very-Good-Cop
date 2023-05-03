extends Node2D
class_name Cursor

var cursor_animator : AnimationPlayer = null
var cursor_sprite : Sprite2D = null

var is_attack_gui : bool = false
var is_idle_gui : bool = true
var is_menu_ui : bool = false
var is_locked_gui : bool = false

var cursor_mode := DisplayServer.MOUSE_MODE_HIDDEN
var cursor_texture = load("res://assets/UI/Cursors/sprCursorMedium.png")

@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer

func active_mode_idle_gui():
	is_idle_gui = true
	is_menu_ui = false
	is_attack_gui = false
	is_locked_gui = false
	set_active_mouse(false)
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_idle")
	visible = true

func active_mode_hit_marker_gui():
	set_active_mouse(false)
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_hit_marker")
	visible = true

func active_mode_attack_gui():
	is_attack_gui = true
	is_menu_ui = false
	is_idle_gui = false
	is_locked_gui = false
	set_active_mouse(false)
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_on_enemy")
	visible = true

func active_mode_locked_gui():
	is_locked_gui = true
	is_attack_gui = false
	is_menu_ui = false
	is_idle_gui = false
	set_active_mouse(false)
	DisplayServer.mouse_set_mode(cursor_mode)
	animator.play("cursor_locked")
	visible = true

func active_mode_ui():
	is_menu_ui = true
	is_attack_gui = false
	is_idle_gui = false
	is_locked_gui = false
	set_active_mouse(true)
	DisplayServer.mouse_set_mode(cursor_mode)
	visible = false

func set_active_mouse(state: bool):
	if state:
		cursor_mode = DisplayServer.MOUSE_MODE_VISIBLE
		DisplayServer.mouse_set_mode(cursor_mode)
	else:
		cursor_mode = DisplayServer.MOUSE_MODE_HIDDEN
		DisplayServer.mouse_set_mode(cursor_mode)
