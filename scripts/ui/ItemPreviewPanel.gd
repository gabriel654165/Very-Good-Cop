extends PanelContainer
class_name ItemPreviewPanel 

#je pense il faut instancier des videos stream quand celui qui est dans le player est finis
# out trouver un moyen de le remettre à 0

@export var video_stream_player : VideoStreamPlayer

func set_preview(preview_path: String):
	video_stream_player.stream.file = preview_path
