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
var mouse_position = Vector2.ZERO

signal ingredients_changed(ingredients : Array[int])

var ingredients: Array[int]
var monster_rewards: Array[int]
var projectile_speed: Array[float]
var projectile_cost: int = 5

var death_timer: Timer
var is_dead = false

func _ready():
	sprite = get_node("Sprite")
	death_timer = get_node("DeathTimer")
	ingredients = [15, 15, 15, 5]
	monster_rewards = [20, 15, 10, 0]
	projectile_speed = [0, 150, 150, 150]
	GlobalManager.monster_killed.connect(on_monster_killed)
	emit_signal("ingredients_changed", ingredients)

func _physics_process(delta):
	if is_dead:
		return
	player_movement(delta)
	
func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"));
	mouse_position = get_global_mouse_position()
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
		pay_ingredients(GlobalManager.IngredientType.CREAM, projectile_cost)
		shoot(GlobalManager.IngredientType.CREAM)
	elif fire_secondary:
		pay_ingredients(GlobalManager.IngredientType.SPICE, projectile_cost)
		shoot(GlobalManager.IngredientType.SPICE)

	move_and_slide()
	turn_sprite(input)
	
func turn_sprite(direction):
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		
func pay_ingredients(ingredient: GlobalManager.IngredientType, cost: int):
	if ingredients[ingredient] - cost <= 0:
		ingredients[ingredient] = 0
		emit_signal("ingredients_changed", ingredients)
		GlobalManager.loss_method = GlobalManager.LossMethod.UNDERFILL
		GlobalManager.loss_ingredient = ingredient
		death_timer.start()
		is_dead = true
		return
	ingredients[ingredient] -= cost
	emit_signal("ingredients_changed", ingredients)
	
func sum(arr: Array):
	var total = 0
	for element in arr:
		total += element
	return total
	
func gain_ingredients(ingredient: GlobalManager.IngredientType, amount: int):
	var total_ingredients = sum(ingredients)
	if total_ingredients + amount >= 100:
		ingredients[ingredient] += min(amount, 100 - total_ingredients)
		emit_signal("ingredients_changed", ingredients)
		GlobalManager.loss_method = GlobalManager.LossMethod.OVERFILL
		GlobalManager.loss_ingredient = ingredient
		death_timer.start()
		is_dead = true
		return
	ingredients[ingredient] += amount
	emit_signal("ingredients_changed", ingredients)
		
func shoot(ingredient: GlobalManager.IngredientType):
	var direction = (mouse_position - global_position).normalized()

	var instance = projectile_prefabs[ingredient].instantiate()
	get_parent().add_child(instance)

	instance.global_position = global_position
	instance.position = position
	instance.velocity = direction * projectile_speed[ingredient]

func take_damage(ingredient: GlobalManager.IngredientType, damage: int):
	pay_ingredients(ingredient, damage)
	

func _on_hurtbox_body_entered(body):
	if body is Monster:
		take_damage(body.ingredient_type, body.damage)


func _on_death_timer_timeout():
	GlobalManager.set_game_state(GlobalManager.GameState.LOSE)
	
func on_monster_killed(type: GlobalManager.IngredientType):
	gain_ingredients(type, monster_rewards[type])
