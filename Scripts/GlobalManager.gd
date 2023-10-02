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
const damage_indicator = preload("res://Scenes/UI/DamageIndicator.tscn")

var strong_matchups = [IngredientType.SPICE, IngredientType.MEAT, IngredientType.CREAM, null, null]
var weak_matchups = [IngredientType.MEAT, IngredientType.CREAM, IngredientType.SPICE, null, null]

func hitlag(time_scale: float, duration: float):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(duration * time_scale).timeout)
	Engine.time_scale = 1.0
	

func is_super_effective(attack: IngredientType, target: IngredientType):
	return get_strong_matchup(attack) == target
	
func get_strong_matchup(attack: IngredientType):
	return strong_matchups[attack]
		
func get_weak_matchup(attack: IngredientType):
	return weak_matchups[attack]
	
func ingredient_type_to_color(type: IngredientType):
	if type == IngredientType.CREAM:
		return Color(255/255.0, 254/255.0, 236/255.0)
	if type == IngredientType.SPICE:
		return Color(232/255.0, 9/255.0, 9/255.0)
	if type == IngredientType.MEAT:
		return Color(99/255.0, 58/255.0, 47/255.0)
	if type == IngredientType.GUAC:
		return Color(77/255.0, 160/255.0, 20/255.0)

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
	
