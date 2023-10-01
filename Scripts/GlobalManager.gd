extends Node2D

enum IngredientTypes {
	CREAM = 0,
	SPICE = 1,
	MEAT = 2,
	GUAC = 3,
	PLAIN = 4
}

enum GameState {
	MENU = 0,
	PLAY = 1,
	WIN = 2,
	LOSE = 3,
	SETTINGS = 4
}

signal nacho_activated
signal game_state_changed


var is_menu_enabled = true
var nacho_count : Array[int] = [0, 0, 0, 0, 0]
var game_state : GameState = GameState.PLAY

func set_game_state(state: GameState):
	if state == game_state:
		return
	game_state = state
	if state == GameState.MENU:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	elif state == GameState.PLAY:
		nacho_count = [0, 0, 0, 0, 0]
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	elif state == GameState.WIN:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
	elif state == GameState.LOSE:
		get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")
	elif state == GameState.SETTINGS:
		get_tree().change_scene_to_file("res://Scenes/SettingsMenu.tscn")
	game_state_changed.emit(game_state)
	
