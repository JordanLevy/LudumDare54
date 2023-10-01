extends Control

var bars : Array[TextureProgressBar]
var player: Node2D

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	player.ingredients_changed.connect(_on_ingredients_changed)
	bars = [null, null, null, null]
	bars[GlobalManager.IngredientTypes.CREAM] = get_node("CreamBar")
	bars[GlobalManager.IngredientTypes.SPICE] = get_node("SpiceBar")
	bars[GlobalManager.IngredientTypes.MEAT] = get_node("MeatBar")
	bars[GlobalManager.IngredientTypes.GUAC] = get_node("GuacBar")

func _on_ingredients_changed(ingredients):
	var total = 0;
	for i in range(0, GlobalManager.IngredientTypes.GUAC + 1):
		bars[i].value = ingredients[i]
		bars[i].position.x = total
		total += ingredients[i] * 1.25
