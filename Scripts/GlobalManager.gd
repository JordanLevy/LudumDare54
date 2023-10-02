extends Node2D

enum IngredientType {
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

enum LossMethod {
	NONE = 0,
	UNDERFILL = 1,
	OVERFILL = 2
}

signal nacho_activated
signal game_state_changed
signal monster_killed


var is_menu_enabled = true
var nacho_count : Array[int] = [0, 0, 0, 0, 0]
var game_state : GameState = GameState.PLAY
var loss_method: LossMethod = LossMethod.NONE
var loss_ingredient: IngredientType = IngredientType.PLAIN

func hitlag(time_scale: float, duration: float):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(duration * time_scale).timeout)
	Engine.time_scale = 1.0

func is_super_effective(attack: IngredientType, target: IngredientType):
	# cream extinguishes spice
	if attack == IngredientType.CREAM:
		return target == IngredientType.SPICE
	# spice burns meat
	if attack == IngredientType.SPICE:
		return target == IngredientType.MEAT
	# meat overpowers cream
	if attack == IngredientType.MEAT:
		return target == IngredientType.CREAM
	return false

func set_game_state(state: GameState):
	if state == game_state:
		return
	game_state = state
	if state == GameState.MENU:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	elif state == GameState.PLAY:
		loss_method = LossMethod.NONE
		loss_ingredient = IngredientType.PLAIN
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	elif state == GameState.WIN:
		nacho_count = [0, 0, 0, 0, 0]
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
	elif state == GameState.LOSE:
		nacho_count = [0, 0, 0, 0, 0]
		get_tree().change_scene_to_file("res://Scenes/LoseScreen.tscn")
	elif state == GameState.SETTINGS:
		get_tree().change_scene_to_file("res://Scenes/SettingsMenu.tscn")
	game_state_changed.emit(game_state)
	
func get_ingredient_name(ingredient: IngredientType):
	if ingredient == IngredientType.PLAIN:
		return "Plain"
	if ingredient == IngredientType.CREAM:
		return "Sour Cream"
	if ingredient == IngredientType.SPICE:
		return "Spicy Salsa"
	if ingredient == IngredientType.MEAT:
		return "Meat"
	if ingredient == IngredientType.GUAC:
		return "Guacamole"
	
