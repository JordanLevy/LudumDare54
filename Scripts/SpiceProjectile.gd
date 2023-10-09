extends Projectile

class_name SpiceProjectile

var player: Player

func _ready():
	knockback = 2
	speed = 150
	endlag = 0.5
	ingredient_type = GlobalManager.IngredientType.SPICE
	player = get_tree().get_root().get_node("Node2D/Player")
	move_and_collide(-player.shoot_offset)
	velocity = player.aim_target * speed

func _on_despawn_timer_timeout():
	despawn()
