extends Projectile

class_name SpiceProjectile

var player: Player

func _ready():
	player_offset = Vector2(0, -40)
	knockback = 2
	speed = 150
	endlag = 0.5
	ingredient_type = GlobalManager.IngredientType.SPICE
	player = get_tree().get_root().get_node("Node2D/Player")
	move_and_collide(player_offset)
	velocity = (target - global_position).normalized() * speed

func _on_despawn_timer_timeout():
	despawn()
