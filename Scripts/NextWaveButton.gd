extends Button

var wave_manager: Node2D

func _ready():
	wave_manager = get_tree().get_root().get_node("Node2D/WaveManager")

func _on_pressed():
	wave_manager.end_upgrade()
	wave_manager.start_wave()
