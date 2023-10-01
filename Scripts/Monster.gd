extends CharacterBody2D

class_name Monster

var player: Player
var health = 10
var speed = 30
var accel = 4
var damage = 10
var ingredient_type = GlobalManager.IngredientType.PLAIN
var nav: NavigationAgent2D

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	nav = get_node("NavigationAgent2D")

func take_damage(amount: int):
	if health - amount <= 0:
		despawn()
	health -= amount
	
func despawn():
	GlobalManager.monster_killed.emit(ingredient_type)
	queue_free()
	
func _on_hurtbox_body_entered(body):
	if body is Projectile:
		take_damage(body.damage)
		body.on_hit()

func _physics_process(delta):
	(await get_tree().process_frame)
	if (global_position - player.global_position).length() <= 10:
		return
	var direction = Vector3()
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * speed * delta
	
	move_and_collide(velocity)
