extends Node2D

var wave_num: int = 0
var enemies_remaining: int = 0
var upgrade_menu: Control

var enemy_prefabs: Array = [
	preload("res://Scenes/Monsters/SpiceMonster.tscn"),
	preload("res://Scenes/Monsters/CreamMonster.tscn"),
	preload("res://Scenes/Monsters/MeatMonster.tscn")
]
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalManager.monster_killed.connect(on_monster_killed)
	player = get_tree().get_root().get_node("Node2D/Player")
	upgrade_menu = get_tree().get_root().get_node("Node2D/CanvasLayer/Control/UpgradeMenu")
	end_upgrade()
	start_wave()
	
func begin_upgrade():
	get_tree().paused = true
	upgrade_menu.begin_upgrade()
	
func end_upgrade():
	upgrade_menu.hide()
	get_tree().paused = false
	
	
func start_wave():
	wave_num += 1
	player.position.x = 0
	player.position.y = 0
	spawn_enemies(wave_num * 3)
	
func end_wave():
	begin_upgrade()
	
func spawn_enemies(num_enemies):
	var angle_increment = 2 * PI / num_enemies
	var radius = 300
	for i in range(num_enemies):
		var angle = i * angle_increment
		spawn_enemy(cos(angle) * radius, sin(angle) * radius, randi() % enemy_prefabs.size())
	enemies_remaining += num_enemies
	
func spawn_enemy(x, y, type):
	var enemy = enemy_prefabs[type].instantiate()
	enemy.position.x = x
	enemy.position.y = y / 2
	enemy.is_aggro = true
	add_child(enemy)

func on_monster_killed(type: GlobalManager.IngredientType):
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		enemies_remaining = 0
		end_wave()
