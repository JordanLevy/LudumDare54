extends Door

class_name MeatDoor

func _ready():
	id = GlobalManager.IngredientTypes.MEAT
	super._ready()
