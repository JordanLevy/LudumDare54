extends Monster

class_name MeatMonster

func _ready():
	super._ready()
	health = 20
	speed = 20
	ingredient_type = GlobalManager.IngredientType.MEAT
