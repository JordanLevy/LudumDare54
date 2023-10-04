extends Monster

class_name SpiceMonster

func _ready():
	super._ready()
	health = 30
	speed = 40
	ingredient_type = GlobalManager.IngredientType.SPICE
