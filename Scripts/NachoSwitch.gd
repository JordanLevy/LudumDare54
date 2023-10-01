extends Area2D

class_name NachoSwitch

signal nacho_switch_activated(door_id: int)

var nacho: AnimatedSprite2D

func _ready():
	nacho = get_node("Nacho")
	nacho.frame = GlobalManager.IngredientTypes.PLAIN
	GlobalManager.nacho_count[nacho.frame] += 1

func change_topping(ingredient: GlobalManager.IngredientTypes):
	# not changing
	if  nacho.frame == ingredient:
		return
	GlobalManager.nacho_count[nacho.frame] -= 1
	GlobalManager.nacho_count[ingredient] += 1
	nacho.frame = ingredient
	print("emit", GlobalManager.nacho_count)
	GlobalManager.nacho_activated.emit()


func _on_body_entered(body):
	print(body)
	if body is Projectile:
		change_topping(body.ingredient_type)
		body.on_hit()
