extends CharacterBody2D

class_name Door

var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var id: int
var is_open: bool = false

func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	collision_shape = get_node("CollisionShape2D")
	GlobalManager.nacho_activated.connect(nacho_switch_activated)
	enable_collision()
	
func open():
	if is_open:
		return
	is_open = true
	animated_sprite.speed_scale = 1
	animated_sprite.animation = "open"
	animated_sprite.play()
	call_deferred("disable_collision")
	
func close():
	if !is_open:
		return
	is_open = false
	animated_sprite.speed_scale = -1
	animated_sprite.animation = "open"
	animated_sprite.play()
	call_deferred("enable_collision")

func enable_collision():
	collision_shape.disabled = false

func disable_collision():
	collision_shape.disabled = true
	
func nacho_switch_activated():
	if GlobalManager.nacho_count[id] >= 1:
		open()
	else:
		close()
	
