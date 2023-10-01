extends CharacterBody2D

class_name Monster

var health

func take_damage(damage: int):
	if health - damage <= 0:
		despawn()
	health -= damage
	
func despawn():
	queue_free()
