extends CharacterBody2D

class_name Player

var projectile_prefabs: Array[PackedScene] = [
		preload("res://Scenes/Projectiles/CreamProjectile.tscn"),
		preload("res://Scenes/Projectiles/SpiceProjectile.tscn"),
		preload("res://Scenes/Projectiles/MeatProjectile.tscn"),
		preload("res://Scenes/Projectiles/GuacProjectile.tscn")
	]

var sprite: AnimatedSprite2D

const max_speed = 200
const accel = 3000
const friction = 1200

var input = Vector2.ZERO
var fire_primary = false
var fire_secondary = false

signal ingredients_changed(ingredients : Array[int])

var ingredients: Array[int]
var projectile_speed: Array[float]
var projectile_cost: int = 0

func _ready():
	sprite = get_node("Sprite")
	ingredients = [30, 20, 30, 10]
	projectile_speed = [0.1, 150, 150, 150]
	emit_signal("ingredients_changed", ingredients)

func _physics_process(delta):
	player_movement(delta)
	
func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"));
	if input.length() > 0:
		input = input.normalized()
	else:
		input = Vector2.ZERO
	fire_primary = Input.is_action_just_pressed("fire_primary")
	fire_secondary = Input.is_action_just_pressed("fire_secondary")

func player_movement(delta):
	get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		input.y *= 0.5
		velocity += input * accel * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = clamp(velocity.y, -max_speed/2.0, max_speed/2.0)
	
	if fire_primary:
		if pay_ingredients(GlobalManager.IngredientTypes.CREAM, projectile_cost):
			shoot(GlobalManager.IngredientTypes.CREAM)
	elif fire_secondary:
		if pay_ingredients(GlobalManager.IngredientTypes.SPICE, projectile_cost):
			shoot(GlobalManager.IngredientTypes.SPICE)

	move_and_slide()
	turn_sprite(input)
	
func turn_sprite(direction):
	if direction.x < 0:
		sprite.scale.x = -1
	elif direction.x > 0:
		sprite.scale.x = 1
		
func pay_ingredients(ingredient: GlobalManager.IngredientTypes, cost: int):
	if ingredients[ingredient] < cost:
		return false
	ingredients[ingredient] -= cost
	emit_signal("ingredients_changed", ingredients)
	return true
		
func shoot(ingredient: GlobalManager.IngredientTypes):
	var target = get_global_mouse_position()
	var direction = (target - global_position).normalized()

	var instance = projectile_prefabs[ingredient].instantiate()
	get_parent().add_child(instance)

	instance.global_position = global_position
	instance.velocity = direction * projectile_speed[ingredient]
