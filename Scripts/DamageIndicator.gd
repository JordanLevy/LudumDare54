extends Node2D

var speed: int = 30
var friction: int = 15
var shift_direction: Vector2 = Vector2.ZERO

var label: Label

func _ready():
	var rng = RandomNumberGenerator.new()
	label = get_node("Label")
	shift_direction = Vector2(rng.randf_range(0, 0), rng.randf_range(-1, 0))

func _process(delta):
	global_position += speed * shift_direction * delta
	speed = max(speed - friction * delta, 0)
