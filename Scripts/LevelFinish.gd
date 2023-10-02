extends Area2D

@export var next_state = GlobalManager.GameState.WIN

func _on_body_entered(body):
	if body is Player:
		GlobalManager.set_game_state(next_state)
