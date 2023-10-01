extends Projectile

class_name CreamProjectile

var area: Area2D
var player: Player

func _ready():
	ingredient_type = GlobalManager.IngredientTypes.CREAM
	player = get_tree().get_root().get_node("Node2D/Player")
	position = player.position
	rotation = atan2(player.mouse_position.y - position.y, player.mouse_position.x - position.x)
	
func on_hit():
	pass
	
func _physics_process(delta):
	position = player.position
	rotation = atan2(player.mouse_position.y - position.y, player.mouse_position.x - position.x)
	super._physics_process(delta)


func _on_timer_timeout():
	despawn()
