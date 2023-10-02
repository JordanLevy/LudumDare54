extends CharacterBody2D

class_name Door

var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D


enum CriteriaType {
	NachoCount = 0,
	PlayerIngredients = 1
}
@export var criteria_type: CriteriaType = CriteriaType.NachoCount
@export var criteria: Array[int] = [1, 0, 0, 0]
var is_open: bool = false
var player: Player
var player_in_range: bool = false

func _ready():
	player = get_tree().get_root().get_node("Node2D/Player")
	animated_sprite = get_node("AnimatedSprite2D")
	collision_shape = get_node("CollisionShape2D")
	player.ingredients_changed.connect(on_ingredients_changed)
	GlobalManager.nacho_activated.connect(nacho_switch_activated)
	enable_collision()
	
func open():
	if is_open:
		return
	GlobalManager.play_sound_effect(GlobalManager.SoundType.OPEN_DOOR, GlobalManager.IngredientType.CREAM, self)
	is_open = true
	animated_sprite.speed_scale = 1
	animated_sprite.animation = "open"
	animated_sprite.play()
	call_deferred("disable_collision")
	
func close():
	if !is_open:
		return
	GlobalManager.play_sound_effect(GlobalManager.SoundType.OPEN_DOOR, GlobalManager.IngredientType.CREAM, self)
	is_open = false
	animated_sprite.speed_scale = -1
	animated_sprite.animation = "open"
	animated_sprite.play()
	call_deferred("enable_collision")

func enable_collision():
	collision_shape.disabled = false

func disable_collision():
	collision_shape.disabled = true
	
func meets_nacho_criteria():
	for i in range(criteria.size()):
		if GlobalManager.nacho_count[i] < criteria[i]:
			return false
	return true
	
func meets_player_criteria():
	print(player.ingredients)
	for i in range(criteria.size()):
		if player.ingredients[i] != criteria[i]:
			return false
	return true
	
	
func nacho_switch_activated():
	if criteria_type != CriteriaType.NachoCount:
		return
	if meets_nacho_criteria():
		open()
	else:
		close()
		
func on_ingredients_changed(ingredients):
	if player_in_range:
		try_open_player_door()
	
func try_open_player_door():
	if criteria_type != CriteriaType.PlayerIngredients:
		return
	if meets_player_criteria():
		open()
	else:
		close()
		GlobalManager.play_sound_effect(GlobalManager.SoundType.DENY_DOOR, GlobalManager.IngredientType.CREAM, self)

func _on_area_2d_body_entered(body):
	player_in_range = true
	if body is Player:
		try_open_player_door()


func _on_area_2d_body_exited(body):
	player_in_range = false
	if criteria_type == CriteriaType.PlayerIngredients:
		close()
