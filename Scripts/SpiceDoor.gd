extends Door

class_name SpiceDoor

func _ready():
	id = GlobalManager.IngredientType.SPICE
	super._ready()
