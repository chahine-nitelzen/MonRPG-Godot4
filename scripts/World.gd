extends Node2D

var player_scene = preload("res://scenes/Player.tscn")
var enemy_scene = preload("res://scenes/Enemy.tscn")
var hud_scene = preload("res://scenes/HUD.tscn")

var zones = {
	"Village": Rect2(40, 60, 230, 180),
	"Forêt": Rect2(340, 80, 300, 230),
	"Grotte": Rect2(690, 120, 220, 220),
	"Ville": Rect2(700, 400, 220, 180),
}

var player = null

func _ready():
	create_player()
	create_enemy(Vector2(400, 220), "Forêt")
	create_enemy(Vector2(520, 260), "Forêt")
	create_enemy(Vector2(760, 180), "Grotte")
	create_enemy(Vector2(810, 450), "Ville")
	spawn_hud()
	update_zone_label()

func _process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	update_zone_label()

func create_player():
	player = player_scene.instantiate()
	player.position = Vector2(100, 100)
	add_child(player)

func create_enemy(pos, zone_name):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemy.zone_name = zone_name
	add_child(enemy)

func spawn_hud():
	var hud = hud_scene.instantiate()
	add_child(hud)

func update_zone_label():
	if player == null:
		return
	var px = player.global_position.x + player.position.x
	var py = player.global_position.y + player.position.y
	var found = "Village"
	for zone_name in zones.keys():
		var zone = zones[zone_name]
		if zone.has_point(Vector2(px, py)):
			found = zone_name
			break
	player.current_zone = found
	player.update_label()
