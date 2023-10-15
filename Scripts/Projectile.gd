extends CharacterBody2D

class_name Projectile

static var cost = 1
var damage = 1
var knockback = 2
var speed = 2
var target = Vector2.ZERO
var endlag = 0.8
var ingredient_type = GlobalManager.IngredientType.PLAIN

func _physics_process(delta):
	move_and_collide(velocity * delta)
	
func on_hit():
	despawn()
	
func despawn():
	queue_free()

