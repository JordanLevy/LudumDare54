extends Door

class_name GuacDoor

func _ready():
	id = GlobalManager.IngredientType.GUAC
	super._ready()
