extends Node2D
class_name TrainingScript

@onready var player = $Player
@onready var projectile_manager = $ProjectileManager

var cursor_offset := Vector2(11, 11)

func _ready():
	GlobalSignals.projectile_fired_spawn.connect(projectile_manager.handle_fired_projectile_spawned)
	GlobalSignals.projectile_launched_spawn.connect(projectile_manager.handle_launched_projectile_spawned)
	GlobalSignals.grappling_cable_drag.connect(projectile_manager.handle_grappling_cable_drag)
	
	init_player()


func _process(delta):
	GlobalVariables.cursor_position = get_viewport().get_mouse_position() - cursor_offset


func init_player():
	player.assign_weapons()


func _unhandled_input(event):
	if event.is_action_pressed("echap"):
		get_tree().change_scene_to_file("res://scenes/main/MainMenu.tscn")
