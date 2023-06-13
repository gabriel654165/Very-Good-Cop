extends Node2D
class_name MainMenu


@onready var cursor_manager = $CanvasLayer/CursorManager


func _ready():
	cursor_manager.set_active(true)
	cursor_manager.cursor.active_mode_ui()


func _on_play_button_up():
	GlobalFunctions.reset_player_levels()
	get_tree().change_scene_to_file("res://scenes/main/MainScene.tscn")


func _on_training_button_button_up():
	get_tree().change_scene_to_file("res://scenes/tuto/TrainingScene.tscn")


func _on_quit_button_up():
	get_tree().quit()
