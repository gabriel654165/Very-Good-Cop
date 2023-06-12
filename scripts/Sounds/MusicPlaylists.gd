extends AudioStreamPlayer
class_name MusicPlaylistsPlayer

# TODO: Might make it work with saves later on
var current_playlist : String
var current_track := 0

var audio_stream_factory := {
	"mp3": func(): return AudioStreamMP3.new(),
	"ogg": func(): return AudioStreamOggVorbis.new(),
	"wav": func(): return AudioStreamWAV.new(),
}


func _ready():
	if !GlobalVariables.playlists.keys().is_empty():
		change_playlist(GlobalVariables.playlists.keys()[2], true, 2)
	play()


func get_playlist_names() -> Array:
	return GlobalVariables.playlists.keys()


func put_track(track:int, play_it:=false):
	assert(track < GlobalVariables.playlists[current_playlist].size(), "Invalid track: " + str(track) + " > "+ current_playlist + " size")
	current_track = track
	stream = GlobalVariables.playlists[current_playlist][track]
	if play_it:
		play()


func next_track(play_it:=false):
	var next_track :int= ((current_track + 1) % GlobalVariables.playlists[current_playlist].size())
	put_track(next_track, play_it)


func change_playlist(playlist:String, play_it:=false, random:=false):
	assert(GlobalVariables.playlists.has(playlist), "Unknown playlist " + playlist)

	current_playlist = playlist
	var first_track : int =  0 if not random else randi() % GlobalVariables.playlists[current_playlist].size()
	put_track(first_track, play_it)


static func get_musics_from_folder(path:String, playlist_track_names: Array) -> Array[AudioStream]:
	var dir = DirAccess.open(path)
	var res : Array[AudioStream]

	if path != "/":
		path += "/"

	assert(dir != null, "Cannot open " + path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path + file_name
		
		if file_name.ends_with(".remap"):
			file_name.trim_suffix(".remap")
		
		var new_stream : AudioStream
		# I don't like it but dunno how to make it better
		if file_name.ends_with("mp3"):
			new_stream = AudioStreamMP3.new()
		elif file_name.ends_with("wav"):
			new_stream = AudioStreamWAV.new()
		elif file_name.ends_with("ogg"):
			new_stream = AudioStreamOggVorbis.new()
		else:
			file_name = dir.get_next()
			continue
		
		var file_bytes := FileAccess.get_file_as_bytes(full_path)
		new_stream.data = file_bytes
		res.append(new_stream)
		playlist_track_names.append(file_name.rsplit(".", true, 1)[0])
		file_name = dir.get_next()

	return res


static func load_all_playlists_from(path:String):
	var dir = DirAccess.open(path)

	assert(dir != null, "Cannot open " + path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path + file_name
		if dir.current_is_dir():
			var playlist_track_names : Array[String] = []
			GlobalVariables.playlists[file_name] = get_musics_from_folder(full_path, playlist_track_names)
			GlobalVariables.playlists_track_names[file_name] = playlist_track_names
		file_name = dir.get_next()


func _on_finished():
	next_track(true)
