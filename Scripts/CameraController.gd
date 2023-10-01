extends Camera2D

var player : Node2D

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")

func center_on_player():
	if player:
		position = lerp(global_position, player.global_position, 0.2);

func _process(_delta):
	center_on_player()
