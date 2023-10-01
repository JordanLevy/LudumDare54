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
	PLAYING = 1,
	WIN = 2,
	LOSE = 3
}

signal nacho_activated

static var nacho_count : Array[int] = [0, 0, 0, 0, 0]

static var game_state : GameState = GameState.PLAYING
