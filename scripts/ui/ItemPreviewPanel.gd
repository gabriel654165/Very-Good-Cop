extends PanelContainer
class_name ItemPreviewPanel 

@export var video_stream_player : VideoStreamPlayer

var video_stream : VideoStreamTheora


func _ready():
	video_stream_player.finished.connect(replay_stream)


func replay_stream():
	video_stream_player.stream_position = 0
	video_stream_player.play()


func set_preview(preview_path: String):
	video_stream = VideoStreamTheora.new()
	video_stream.file = preview_path
	video_stream_player.stream = video_stream
	video_stream_player.play()
