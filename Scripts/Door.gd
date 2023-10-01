extends CharacterBody2D

class_name Door

var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var id: int

func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	collision_shape = get_node("CollisionShape2D")
	GlobalManager.nacho_activated.connect(nacho_switch_activated)
	
func open():
	animated_sprite.animation = "open"
	animated_sprite.play()
	call_deferred("disable")
	
func disable():
	collision_shape.disabled = true
	
func nacho_switch_activated():
	if GlobalManager.nacho_count[id] >= 1:
		open()
	
