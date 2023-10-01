extends Monster

class_name CreamMonster

func _ready():
	super._ready()
	health = 10
	ingredient_type = GlobalManager.IngredientType.CREAM
