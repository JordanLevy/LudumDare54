extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_button_pressed():
	GlobalManager.set_game_state(GlobalManager.GameState.MENU)


func _on_mute_music_button_pressed():
	GlobalManager.toggle_mute_music.emit()
