extends CharacterBody2D

class_name Projectile

var player_offset = Vector2.ZERO
var damage = 1
var knockback = 2
var speed = 2
var target = Vector2.ZERO
var endlag = 1
var ingredient_type = GlobalManager.IngredientType.PLAIN

func _physics_process(delta):
	move_and_collide(velocity * delta)
	
func on_hit():
	despawn()
	
func despawn():
	queue_free()

