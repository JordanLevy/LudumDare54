extends Projectile

class_name MeatProjectile

var player: Player

func _ready():
	player_offset = Vector2(0, -30)
	damage = 15
	knockback = -5
	speed = 40
	ingredient_type = GlobalManager.IngredientType.MEAT
	player = get_tree().get_root().get_node("Node2D/Player")
	velocity = player.velocity.normalized()
	move_and_collide(player_offset)
	
func on_hit():
	pass
	
func _physics_process(delta):
	move_and_collide(player.global_position - position + player_offset)

func _on_despawn_timer_timeout():
	despawn()
