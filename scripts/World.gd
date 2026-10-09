extends Node2D

var player_scene = preload("res://scenes/Player.tscn")
var enemy_scene = preload("res://scenes/Enemy.tscn")
var hud_scene = preload("res://scenes/HUD.tscn")
var quest_system = QuestSystem.new()
var save_system = SaveSystem.new()
var player = null

var enemy_types = [
	{"name": "Slime", "gold": 10, "hp": 30, "damage": 8, "speed": 30.0},
	{"name": "Goblin", "gold": 15, "hp": 40, "damage": 10, "speed": 35.0},
	{"name": "Squelette", "gold": 20, "hp": 50, "damage": 12, "speed": 35.0},
]

var zones = {
	"Village": Rect2(40, 60, 280, 220),
	"Forêt": Rect2(400, 120, 280, 220),
	"Grotte": Rect2(770, 130, 220, 220),
	"Ville": Rect2(760, 420, 220, 180),
}

func _ready():
	add_to_group("world")
	create_player()
	create_enemy(Vector2(450, 220), "Slime")
	create_enemy(Vector2(560, 260), "Goblin")
	create_enemy(Vector2(820, 200), "Squelette")
	spawn_hud()
	update_zone_label()
	save_system.load_player(player)
	print("Vue du monde: prêt")

func _process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	update_zone_label()
	if player.quest_done and player.current_zone == "Village":
		print("La quête est terminée. Retourne voir le chef !")

func create_player():
	player = player_scene.instantiate()
	player.position = Vector2(110, 110)
	player.quest_system = quest_system
	player.save_system = save_system
	add_child(player)
	player.current_quest = quest_system.title
	player.quest_goal = quest_system.goal
	player.quest_progress = quest_system.progress
	player.quest_done = quest_system.is_complete

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
	add_child(enemy)

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
	if enemy_name == "Slime":
		if player.quest_system != null:
			player.quest_system.add_progress(1)
			player.quest_progress = player.quest_system.progress
			player.quest_goal = player.quest_system.goal
			player.quest_done = player.quest_system.is_complete
			if player.quest_system.is_complete:
				player.gold += 30
				player.add_item("Herbe", 1)
				print("Quête terminée ! Tu reçois 30 or et une herbe.")
			else:
				print("Quest en cours : ", player.quest_system.get_text())
		save_game()
		return

func save_game():
	if player == null:
		return
	if save_system != null:
		save_system.save_player(player)

func load_game():
	if save_system != null:
		save_system.load_player(player)
