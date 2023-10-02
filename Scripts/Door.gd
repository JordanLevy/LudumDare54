extends CharacterBody2D

class_name Door

var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
@export var criteria: Array[int] = [1, 0, 0, 0]
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
	
func meets_criteria():
	for i in range(criteria.size()):
		if GlobalManager.nacho_count[i] < criteria[i]:
			return false
	return true
	
func nacho_switch_activated():
	if meets_criteria():
		open()
	else:
		close()
	
