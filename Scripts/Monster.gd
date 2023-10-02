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

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	nav = get_node("NavigationAgent2D")
	sprite = get_node("Sprite")

func take_damage(damage_type: GlobalManager.IngredientType, amount: int):
	if GlobalManager.is_super_effective(damage_type, ingredient_type):
		amount *= 2.0
	if health - amount <= 0:
		despawn()
	health -= amount
	
func take_knockback(direction: Vector2, amount: float):
	print(direction * amount * knockback_coefficient)
	move_and_collide(direction * amount * knockback_coefficient)
	
func despawn():
	GlobalManager.monster_killed.emit(ingredient_type)
	queue_free()
	
func _on_hurtbox_body_entered(body):
	if body is Projectile:
		take_damage(body.ingredient_type, body.damage)
		take_knockback(body.velocity.normalized(), body.knockback)
		body.on_hit()

func _physics_process(delta):
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
	
	
