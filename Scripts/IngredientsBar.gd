extends Control

var bars : Array[TextureProgressBar]
var player: Node2D
@export var is_door_label = false
@export var door_label_ingredients = [10, 10, 10, 10]

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	player.ingredients_changed.connect(_on_ingredients_changed)
	bars = [null, null, null, null]
	bars[GlobalManager.IngredientType.CREAM] = get_node("CreamBar")
	bars[GlobalManager.IngredientType.SPICE] = get_node("SpiceBar")
	bars[GlobalManager.IngredientType.MEAT] = get_node("MeatBar")
	bars[GlobalManager.IngredientType.GUAC] = get_node("GuacBar")
	if is_door_label:
		update(door_label_ingredients)

func _on_ingredients_changed(ingredients):
	if !is_door_label:
		update(ingredients)
		
func update(ingredients):
	var total: float = 0;
	for i in range(0, GlobalManager.IngredientType.GUAC + 1):
		var percentage = ingredients[i] * GlobalManager.ingredients_per_scoop
		percentage *= GlobalManager.max_ingredient_capacity
		percentage /= float(GlobalManager.max_ingredient_capacity)
		bars[i].value = percentage
		bars[i].position.x = total
		total += percentage
