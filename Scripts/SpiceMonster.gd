extends Monster

class_name SpiceMonster

func _ready():
	super._ready()
	health = 10
	ingredient_type = GlobalManager.IngredientType.SPICE
