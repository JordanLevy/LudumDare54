extends Control

@export var init_focused: bool = false
@export var target_game_state: GlobalManager.GameState
@export var toggles_mute: bool = false

func _ready():
	if init_focused:
		grab_focus()

func _on_pressed():
	if toggles_mute:
		GlobalManager.toggle_mute_music.emit()
	else:
		GlobalManager.set_game_state(target_game_state)
