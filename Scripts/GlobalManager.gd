extends Node2D

enum IngredientTypes {
	CREAM = 0,
	SPICE = 1,
	MEAT = 2,
	GUAC = 3
}

enum GameState {
	MENU = 0,
	PLAYING = 1,
	WIN = 2,
	LOSE = 3
}

static var game_state : GameState = GameState.PLAYING
