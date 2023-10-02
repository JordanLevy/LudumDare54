extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_button_pressed():
	GlobalManager.set_game_state(GlobalManager.GameState.TUTORIAL)


func _on_settings_button_pressed():
	GlobalManager.set_game_state(GlobalManager.GameState.SETTINGS)
