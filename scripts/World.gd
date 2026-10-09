extends Node2D

var player_scene = preload("res://scenes/Player.tscn")
var enemy_scene = preload("res://scenes/Enemy.tscn")
var boss_scene = preload("res://scenes/Boss.tscn")
var hud_scene = preload("res://scenes/HUD.tscn")
var victory_scene = preload("res://scenes/VictoryScreen.tscn")

var player = null
var victory_triggered = false

var enemy_types = [
	{"name": "Slime", "gold": 10, "hp": 20, "damage": 5, "speed": 20.0, "xp": 15},
	{"name": "Goblin", "gold": 25, "hp": 35, "damage": 10, "speed": 30.0, "xp": 25},
	{"name": "Squelette", "gold": 40, "hp": 50, "damage": 12, "speed": 25.0, "xp": 35},
	{"name": "Ogre", "gold": 60, "hp": 70, "damage": 15, "speed": 20.0, "xp": 50},
]

var zones = {
	"Village": Rect2(20, 40, 280, 240),
	"Forêt": Rect2(380, 80, 320, 240),
	"Grotte": Rect2(750, 120, 240, 240),
	"Caverne du Dragon": Rect2(900, 380, 200, 200),
}

func _ready():
	add_to_group("world")
	create_player()
	create_enemy(Vector2(450, 220), "Slime")
	create_enemy(Vector2(560, 260), "Goblin")
	create_enemy(Vector2(650, 180), "Slime")
	create_enemy(Vector2(820, 200), "Squelette")
	create_enemy(Vector2(850, 280), "Ogre")
	create_boss(Vector2(950, 450))
	spawn_hud()
	update_zone_label()
	print("Monde chargé - Aventure prête à débuter!")

func _process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	update_zone_label()

func create_player():
	player = player_scene.instantiate()
	player.position = Vector2(110, 110)
	add_child(player)

func create_enemy(pos, enemy_name):
	var enemy_cfg = null
	for item in enemy_types:
		if item["name"] == enemy_name:
			enemy_cfg = item
			break
	if enemy_cfg == null:
		return
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemy.enemy_name = enemy_name
	enemy.hp = enemy_cfg["hp"]
	enemy.max_hp = enemy_cfg["hp"]
	enemy.speed = enemy_cfg["speed"]
	enemy.damage = enemy_cfg["damage"]
	enemy.gold_reward = enemy_cfg["gold"]
	enemy.xp_reward = enemy_cfg["xp"]
	add_child(enemy)

func create_boss(pos):
	var boss = boss_scene.instantiate()
	boss.position = pos
	add_child(boss)

func spawn_hud():
	var hud = hud_scene.instantiate()
	hud.set_world(self)
	add_child(hud)

func update_zone_label():
	if player == null:
		return
	for zone_name in zones.keys():
		if zones[zone_name].has_point(player.position):
			player.current_zone = zone_name
			break
	player.update_label()

func on_enemy_defeated(enemy_name):
	if enemy_name == "Slime" or enemy_name == "Goblin" or enemy_name == "Squelette" or enemy_name == "Ogre":
		if player:
			player.quest_progress += 1
			if player.quest_progress >= player.quest_goal:
				player.quest_done = True
				print("\n=== QUÊTE INTERMÉDIAIRE COMPLÉTÉE ===")
				print("Tu peux maintenant affronter le Dragon!")


func on_game_victory():
	if not victory_triggered:
		victory_triggered = True
		await get_tree().create_timer(2.0).timeout
		var victory_screen = victory_scene.instantiate()
		add_child(victory_screen)
