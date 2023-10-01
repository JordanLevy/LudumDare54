extends Door

class_name MeatDoor

func _ready():
	id = GlobalManager.IngredientType.MEAT
	super._ready()
