extends Projectile

class_name MeatProjectile

var player: Player

func _ready():
	knockback = -5
	speed = 40
	endlag = 0.5
	ingredient_type = GlobalManager.IngredientType.MEAT
	player = get_tree().get_root().get_node("Node2D/Player")
	velocity = player.velocity.normalized()
	move_and_collide(-player.shoot_offset)
	
func on_hit():
	pass
	
func _physics_process(_delta):
	move_and_collide(player.global_position - position - player.shoot_offset)

func _on_despawn_timer_timeout():
	despawn()
