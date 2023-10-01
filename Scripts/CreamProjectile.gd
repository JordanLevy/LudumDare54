extends Projectile

class_name CreamProjectile

var area: Area2D
var player: Player

func _ready():
	knockback = 10
	player_offset = Vector2(0, -20)
	ingredient_type = GlobalManager.IngredientType.CREAM
	player = get_tree().get_root().get_node("Node2D/Player")
	position = player.position + player_offset
	rotation = atan2(player.mouse_position.y - position.y, player.mouse_position.x - position.x)
	
func on_hit():
	pass
	
func _physics_process(delta):
	position = player.position + player_offset
	rotation = atan2(player.mouse_position.y - position.y, player.mouse_position.x - position.x)
	super._physics_process(delta)


func _on_timer_timeout():
	despawn()
