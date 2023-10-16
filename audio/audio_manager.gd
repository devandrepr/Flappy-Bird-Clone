extends Node
# Thanks to Retrobright @ https://www.youtube.com/watch?v=mnm7uV4MOTk


func play(audio_stream: AudioStream) -> void:
	var _player := AudioStreamPlayer.new()
	_player.process_mode = Node.PROCESS_MODE_ALWAYS
	_player.stream = audio_stream
	_player.finished.connect(_on_player_finished.bind(_player))
	add_child(_player)
	_player.play()


func _on_player_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
