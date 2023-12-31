extends CharacterBody2D

class_name NachoSwitch

signal nacho_switch_activated(door_id: int)

var nacho: AnimatedSprite2D

func _ready():
	nacho = get_node("Nacho")
	nacho.frame = GlobalManager.IngredientType.PLAIN
	GlobalManager.nacho_count[nacho.frame] += 1

func change_topping(ingredient: GlobalManager.IngredientType):
	# not changing
	if  nacho.frame == ingredient:
		return
	GlobalManager.nacho_count[nacho.frame] -= 1
	GlobalManager.nacho_count[ingredient] += 1
	nacho.frame = ingredient
	GlobalManager.nacho_activated.emit()

func _on_area_2d_body_entered(body):
	if body is Projectile:
		change_topping(body.ingredient_type)
		GlobalManager.play_sound_effect(GlobalManager.SoundType.HIT_NACHO, body.ingredient_type, self)
		body.on_hit()
