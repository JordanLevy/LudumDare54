extends Node2D

var sprite: Sprite2D
var speed = 200

signal ingredients_changed(ingredients : Array[int])

var ingredients: Array[int]

func _ready():
	sprite = get_node("Sprite")
	ingredients = [10, 20, 30, 40]
	emit_signal("ingredients_changed", ingredients)

func _process(delta):
	process_movement(delta)

func process_movement(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"));
	if direction.length() > 0:
		direction = direction.normalized()
	direction.y /= 2.0;
	position += direction * speed * delta
	turn_sprite(direction)
	
func turn_sprite(direction):
	if direction.x < 0:
		sprite.scale.x = -1
	elif direction.x > 0:
		sprite.scale.x = 1
