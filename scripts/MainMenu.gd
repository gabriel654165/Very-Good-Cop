extends Node2D
class_name MainMenu

@onready var cursor_manager = $CanvasLayer/CursorManager
@onready var music_playlist_player : MusicPlaylistsPlayer = $MusicPlaylistsPlayer

@export var animator : AnimationPlayer


func _ready():
	cursor_manager.set_active(true)
	cursor_manager.cursor.active_mode_ui()
	music_playlist_player.init()
	animator.play("unzoom_and_fade_out")


func start_new_game():
	get_tree().change_scene_to_file("res://scenes/main/MainScene.tscn")


func start_training_game():
	get_tree().change_scene_to_file("res://scenes/tuto/TrainingScene.tscn")


func _on_play_button_up():
	GlobalFunctions.reset_player_levels()
	animator.play("zoom_and_fade")


func _on_training_button_button_up():
	animator.play("zoom_and_fade_2")


func _on_quit_button_up():
	get_tree().quit()

