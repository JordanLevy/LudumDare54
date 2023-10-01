extends Door

class_name SpiceDoor

func _ready():
	id = GlobalManager.IngredientTypes.SPICE
	super._ready()
