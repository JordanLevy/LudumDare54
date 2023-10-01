extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_button_pressed():
	if GlobalManager.is_menu_enabled:
		GlobalManager.set_game_state(GlobalManager.GameState.MENU)
	else:
		GlobalManager.set_game_state(GlobalManager.GameState.PLAY)
