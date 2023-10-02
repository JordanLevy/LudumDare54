extends AudioStreamPlayer

func _ready():
	GlobalManager.toggle_mute_music.connect(on_toggle_mute)
	playing = true

func on_toggle_mute():
	playing = !playing
