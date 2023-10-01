extends Area2D

func _on_body_entered(body):
	if body is Player:
		GlobalManager.set_game_state(GlobalManager.GameState.WIN)
