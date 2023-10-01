extends Projectile

class_name CreamProjectile

var area: Area2D

func _ready():
	ingredient_type = GlobalManager.IngredientTypes.CREAM
	
func on_hit():
	pass
