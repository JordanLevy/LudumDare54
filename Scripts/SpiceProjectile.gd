extends Projectile

class_name SpiceProjectile

var player: Player

func _ready():
	player_offset = Vector2(0, -40)
	ingredient_type = GlobalManager.IngredientType.CREAM
	player = get_tree().get_root().get_node("Node2D/Player")
	move_and_collide(player_offset)

func _on_despawn_timer_timeout():
	despawn()
