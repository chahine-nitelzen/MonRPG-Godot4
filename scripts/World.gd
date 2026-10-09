extends Node2D

var player_scene = preload("res://scenes/Player.tscn")
var enemy_scene = preload("res://scenes/Enemy.tscn")
var hud_scene = preload("res://scenes/HUD.tscn")

func _ready():
	create_player()
	create_enemy(Vector2(350, 220))
	create_enemy(Vector2(650, 250))
	create_enemy(Vector2(830, 360))
	spawn_hud()

func create_player():
	var player = player_scene.instantiate()
	player.position = Vector2(100, 100)
	add_child(player)

func create_enemy(pos):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	add_child(enemy)

func spawn_hud():
	var hud = hud_scene.instantiate()
	add_child(hud)
