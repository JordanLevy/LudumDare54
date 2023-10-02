extends Control

var bars : Array[TextureProgressBar]
var player: Node2D

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	player.ingredients_changed.connect(_on_ingredients_changed)
	bars = [null, null, null, null]
	bars[GlobalManager.IngredientType.CREAM] = get_node("CreamBar")
	bars[GlobalManager.IngredientType.SPICE] = get_node("SpiceBar")
	bars[GlobalManager.IngredientType.MEAT] = get_node("MeatBar")
	bars[GlobalManager.IngredientType.GUAC] = get_node("GuacBar")

func _on_ingredients_changed(ingredients):
	var total: float = 0;
	for i in range(0, GlobalManager.IngredientType.GUAC + 1):
		bars[i].value = ingredients[i]
		bars[i].position.x = total
		total += floor(ingredients[i] * 1)
