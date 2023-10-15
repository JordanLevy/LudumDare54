extends CharacterBody2D

class_name Player

var projectile_prefabs: Array[PackedScene] = [
		preload("res://Scenes/Projectiles/CreamProjectile.tscn"),
		preload("res://Scenes/Projectiles/SpiceProjectile.tscn"),
		preload("res://Scenes/Projectiles/MeatProjectile.tscn"),
		preload("res://Scenes/Projectiles/GuacProjectile.tscn")
	]

var sprite: AnimatedSprite2D

const dash_speed = 50000
var dash_velocity = Vector2.ZERO

var max_speed = 200

var accel = 3000

const friction = 1200

var input = Vector2.ZERO
var fire_cream = false
var fire_spice = false
var fire_meat = false

var mouse_position = Vector2.ZERO
var mouse_aim = Vector2.ZERO
var controller_aim = Vector2.ZERO
var aim_target = Vector2.ZERO
var shoot_offset = Vector2(0, 30)

signal ingredients_changed(ingredients : Array[int])

var ingredients: Array[int]
var monster_rewards: Array[int]

var dash_timer: Timer

var death_timer: Timer
var is_dead = false

var endlag_timer: Timer

var knockback_coefficient = 10

var aim_arrow_pivot: Node2D
var is_using_mouse_aim = true

func _ready():
	sprite = get_node("Sprite")
	dash_timer = get_node("DashTimer")
	death_timer = get_node("DeathTimer")
	endlag_timer = get_node("EndlagTimer")
	aim_arrow_pivot = get_node("AimArrowPivot")
	ingredients = [20, 20, 20, 20]
	monster_rewards = [20, 20, 20, 20]
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
	mouse_aim = (mouse_position + shoot_offset - global_position).normalized()
	var controller_x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	var controller_y = Input.get_action_strength("aim_up") - Input.get_action_strength("aim_down")
	controller_aim = Vector2(controller_x, -controller_y).normalized()
	
	if controller_aim.length() > 0:
		is_using_mouse_aim = false
		
	if is_using_mouse_aim:
		aim_target = mouse_aim
	elif controller_aim.length() > 0:
			aim_target = controller_aim
		
	if input.length() > 0:
		input = input.normalized()
	else:
		input = Vector2.ZERO
	fire_cream = Input.is_action_pressed("fire_cream")
	fire_spice = Input.is_action_pressed("fire_spice")
	fire_meat = Input.is_action_pressed("fire_meat")
	aim_arrow_pivot.rotation = atan2(aim_target.y, aim_target.x)
	

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
	
	if endlag_timer.is_stopped():
		if fire_cream:
			pay_ingredients(GlobalManager.IngredientType.CREAM, CreamProjectile.cost)
			shoot(GlobalManager.IngredientType.CREAM)
		elif fire_spice:
			pay_ingredients(GlobalManager.IngredientType.SPICE, SpiceProjectile.cost)
			shoot(GlobalManager.IngredientType.SPICE)
		elif fire_meat:
			pay_ingredients(GlobalManager.IngredientType.MEAT, MeatProjectile.cost)
			shoot(GlobalManager.IngredientType.MEAT)
			start_dash()
		
	if not dash_timer.is_stopped():
		velocity = dash_velocity * delta

	move_and_slide()
	turn_sprite(input)
	
func turn_sprite(direction):
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
		
func pay_ingredients(ingredient: GlobalManager.IngredientType, cost: int):
	if is_dead:
		return
	spawn_damage_indicator(str(-cost), global_position, ingredient)
	if GlobalManager.infinite_ingredients:
		return
	if ingredients[ingredient] - cost <= 0:
		
		ingredients[ingredient] = 0
		ingredients_changed.emit(ingredients)
		GlobalManager.loss_method = GlobalManager.LossMethod.UNDERFILL
		GlobalManager.loss_ingredient = ingredient
		death_timer.start()
		is_dead = true
		return
	ingredients[ingredient] -= cost
	ingredients_changed.emit(ingredients)
	
func sum(arr: Array):
	var total = 0
	for element in arr:
		total += element
	return total
	
func gain_ingredients(ingredient: GlobalManager.IngredientType, amount: int):
	if is_dead or GlobalManager.infinite_ingredients:
		return
	var total_ingredients = sum(ingredients)
	spawn_damage_indicator("+" + str(amount), global_position, ingredient)
	if total_ingredients + amount >= GlobalManager.max_num_scoops:
		ingredients[ingredient] += amount
		ingredients_changed.emit(ingredients)
		GlobalManager.loss_method = GlobalManager.LossMethod.OVERFILL
		GlobalManager.loss_ingredient = ingredient
		death_timer.start()
		is_dead = true
		return
	ingredients[ingredient] += amount
	ingredients_changed.emit(ingredients)
		
func shoot(ingredient: GlobalManager.IngredientType):
	GlobalManager.play_sound_effect(GlobalManager.SoundType.SHOOT, ingredient, self)
	var instance = projectile_prefabs[ingredient].instantiate()
	instance.target = aim_target
	instance.global_position = global_position
	get_parent().add_child(instance)
	endlag_timer.wait_time = instance.endlag
	endlag_timer.start()
	
func start_dash():
	dash_timer.start()
	dash_velocity = aim_target * dash_speed

func spawn_effect(effect: PackedScene, pos: Vector2):
	var instance = effect.instantiate()
	add_child(instance)
	instance.global_position = pos
	return instance
	
func spawn_damage_indicator(text: String, pos: Vector2, type: GlobalManager.IngredientType):
	var indicator = spawn_effect(GlobalManager.damage_indicator, pos)
	indicator.label.text = str(text)
	indicator.label.label_settings.set_font_color(GlobalManager.ingredient_type_to_color(type))

func take_damage(ingredient: GlobalManager.IngredientType, damage: int):
	if not dash_timer.is_stopped():
		return
	pay_ingredients(ingredient, damage)
	
func take_knockback(direction: Vector2, amount: float):
	move_and_collide(direction * amount * knockback_coefficient)

func _on_hurtbox_body_entered(body):
	if not dash_timer.is_stopped():
		return
	if body is Monster:
		velocity = Vector2.ZERO
		var kbv = (global_position - body.global_position).normalized()
		take_damage(GlobalManager.get_strong_matchup(body.ingredient_type), body.damage)
		await GlobalManager.hitlag(0.1, 0.4)
		take_knockback(kbv, 4)
		GlobalManager.play_sound_effect(GlobalManager.SoundType.HIT_PLAYER, body.ingredient_type, self)


func _on_death_timer_timeout():
	GlobalManager.set_game_state(GlobalManager.GameState.LOSE)
	
func on_monster_killed(type: GlobalManager.IngredientType):
	gain_ingredients(type, monster_rewards[type])


func _on_dash_timer_timeout():
	velocity = Vector2.ZERO
	
func _input(event):
	if event is InputEventMouseMotion:
		var mouse_motion = event.relative
		if mouse_motion.length() > 0:
			is_using_mouse_aim = true
