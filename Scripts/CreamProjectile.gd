extends Projectile

class_name CreamProjectile

var area: Area2D
var player: Player

func _ready():
	knockback = 7
	speed = 1
	endlag = 0.8
	ingredient_type = GlobalManager.IngredientType.CREAM
	player = get_tree().get_root().get_node("Node2D/Player")
	position = player.position - player.shoot_offset
	rotation = atan2(player.aim_target.y, player.aim_target.x)
	velocity = player.aim_target * speed
	
	
func on_hit():
	pass
	
func _physics_process(delta):
	position = player.position - player.shoot_offset
	rotation = atan2(player.aim_target.y, player.aim_target.x)
	super._physics_process(delta)


func _on_timer_timeout():
	despawn()
