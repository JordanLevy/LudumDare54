extends Door

class_name CreamDoor

func _ready():
	id = GlobalManager.IngredientType.CREAM
	super._ready()
