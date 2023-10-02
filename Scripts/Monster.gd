extends CharacterBody2D

class_name Monster

var player: Player
var health = 30
var speed = 30
var accel = 4
var damage = 10
var ingredient_type = GlobalManager.IngredientType.PLAIN
var nav: NavigationAgent2D
var sprite: AnimatedSprite2D
var flip_sprite = false
var flip_threshold = 0.4
var flip_cooldown = 0.5
var time_since_last_flip = 0
var knockback_coefficient = 10
var is_aggro: bool = false
var sight_range = 250

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	nav = get_node("NavigationAgent2D")
	sprite = get_node("Sprite")

func spawn_effect(effect: PackedScene, pos: Vector2):
	var instance = effect.instantiate()
	add_child(instance)
	instance.global_position = pos
	return instance
	
func spawn_damage_indicator(text: String, pos: Vector2, type: GlobalManager.IngredientType):
	var indicator = spawn_effect(GlobalManager.damage_indicator, pos)
	indicator.label.text = str(text)
	indicator.label.label_settings.set_font_color(GlobalManager.ingredient_type_to_color(type))

func take_damage(damage_type: GlobalManager.IngredientType, amount: int):
	var text = "{amount}"
	if GlobalManager.is_super_effective(damage_type, ingredient_type):
		amount *= 2
		text = "*{amount}*"
	
	spawn_damage_indicator(text.format({"amount": -amount/5.0}), global_position, damage_type)
	if health - amount <= 0:
		despawn()
	health -= amount
	
func take_knockback(direction: Vector2, amount: float):
	move_and_collide(direction * amount * knockback_coefficient)
	
func despawn():
	GlobalManager.monster_killed.emit(ingredient_type)
	queue_free()
	
func _on_hurtbox_body_entered(body):
	if body is Projectile:
		var kbv = body.velocity.normalized()
		var bk = body.knockback
		take_damage(body.ingredient_type, body.damage)
		if ingredient_type == GlobalManager.IngredientType.MEAT:
			await GlobalManager.hitlag(0.1, 0.2)
		take_knockback(kbv, bk)
		body.on_hit()

func _physics_process(delta):
	if (global_position - player.global_position).length() <= sight_range:
		is_aggro = true
	if !is_aggro:
		return
	time_since_last_flip += delta
	(await get_tree().process_frame)
	var direction = Vector3()
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * speed * delta
	
	move_and_collide(velocity)
	turn_sprite(velocity)
	
func turn_sprite(direction):
	if time_since_last_flip >= flip_cooldown:
		sprite.flip_h = flip_sprite
		time_since_last_flip = 0
	if direction.x > flip_threshold:
		flip_sprite = true
	elif direction.x < -flip_threshold:
		flip_sprite = false
	
	
