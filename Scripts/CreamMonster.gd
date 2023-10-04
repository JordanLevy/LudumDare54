extends Monster

class_name CreamMonster

func _ready():
	super._ready()
	health = 20
	speed = 30
	ingredient_type = GlobalManager.IngredientType.CREAM
