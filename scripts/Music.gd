extends AudioStreamPlayer



func _on_finished():
	var spb = 60.0 / stream.bpm
	await get_tree().create_timer(spb * stream.bar_beats * 2).timeout
	play()
