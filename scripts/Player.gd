extends CharacterBody2D

const SPEED = 140.0

var hp = 100
var max_hp = 100
var gold = 100
var damage = 15
var potion_count = 5
var attack_cooldown = 0.0
var inventory = {
	"Potion": 5,
	"Épée": 1,
	"Armure": 0,
	"Herbe magique": 0,
	"Pierre de pouvoir": 0,
}
var current_zone = "Village"
var current_quest = "Enquête sur le dragon"
var quest_progress = 0
var quest_goal = 5
var quest_done = false
var quest_log = []
var level = 1
var experience = 0
var experience_to_level = 100

@onready var label = $Label

func _ready():
	add_to_group("player")
	quest_log.append("Enquête sur le dragon - Tuer 5 créatures")
	update_label()

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	if direction.length() > 0:
		direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	attack_cooldown = max(0.0, attack_cooldown - delta)

	if direction.x < 0:
		$Body.scale.x = -1
	elif direction.x > 0:
		$Body.scale.x = 1

func _input(event):
	if event.is_action_pressed("attack"):
		attack_nearest_enemy()
	if event.is_action_pressed("use_potion"):
		use_potion()
	if event.is_action_pressed("ui_accept"):
		interact_with_world()
	if event.is_action_pressed("inventory"):
		open_inventory_menu()

func update_label():
	if label:
		var quest_text = current_quest
		if quest_done:
			quest_text += " ✓"
		label.text = "Niveau: %d | PV: %s/%s | Or: %s | XP: %s/%s\nZone: %s | Quête: %s (%s/%s)\nInventaire: %s" % [level, hp, max_hp, gold, experience, experience_to_level, current_zone, quest_text, quest_progress, quest_goal, stringify_inventory()]

func stringify_inventory():
	var result = []
	for item in inventory.keys():
		if inventory[item] > 0:
			result.append(item + "x" + str(inventory[item]))
	if result.is_empty():
		return "vide"
	return " | ".join(result)

func attack_nearest_enemy():
	if attack_cooldown > 0:
		return
	attack_cooldown = 0.5

	var nearest = null
	var nearest_dist = INF
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy == null or not enemy.is_inside_tree():
			continue
		if enemy.hp <= 0:
			continue
		var d = global_position.distance_to(enemy.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = enemy

	if nearest != null and nearest_dist < 50:
		var damage_dealt = damage + randi() % 5
		nearest.hp -= damage_dealt
		print("Tu frappes ", nearest.name, " pour ", damage_dealt, " dégâts.")
		if nearest.hp <= 0:
			nearest.queue_free()
			gold += nearest.gold_reward
			add_experience(nearest.xp_reward)
			if get_tree().has_group("world"):
				get_tree().call_group("world", "on_enemy_defeated", nearest.enemy_name)
			print("Ennemi tué ! +", nearest.gold_reward, " or, +", nearest.xp_reward, " XP")
		update_label()
	else:
		print("Aucun ennemi proche.")

func take_damage(amount):
	hp -= amount
	hp = max(0, hp)
	update_label()
	if hp <= 0:
		print("Tu es mort !")
		get_tree().reload_current_scene()

func use_potion():
	if potion_count <= 0:
		print("Plus de potions")
		return
	if hp >= max_hp:
		print("Ta vie est déjà au maximum")
		return
	potion_count -= 1
	inventory["Potion"] = potion_count
	hp = min(max_hp, hp + 50)
	update_label()
	print("Tu bois une potion. +50 PV")

func add_experience(amount):
	experience += amount
	if experience >= experience_to_level:
		level_up()
	update_label()

func level_up():
	level += 1
	experience = 0
	experience_to_level = int(experience_to_level * 1.5)
	max_hp += 20
	hp = max_hp
	damage += 5
	print("=== MONTÉE DE NIVEAU ===")
	print("Tu es maintenant niveau ", level)
	print("PV max: +20, Dégâts: +5")
	print("======================")

func buy_potion():
	if gold < 10:
		print("Tu n'as pas assez d'or pour acheter une potion.")
		return
	gold -= 10
	potion_count += 1
	inventory["Potion"] = potion_count
	update_label()
	print("Tu achètes une potion pour 10 or.")

func buy_sword():
	if gold < 25:
		print("Tu n'as pas assez d'or pour acheter une épée.")
		return
	gold -= 25
	damage += 8
	inventory["Épée"] += 1
	update_label()
	print("Tu achètes une épée. +8 dégâts.")

func buy_armor():
	if gold < 40:
		print("Tu n'as pas assez d'or pour acheter une armure.")
		return
	gold -= 40
	max_hp += 30
	hp = max_hp
	inventory["Armure"] += 1
	update_label()
	print("Tu achètes une armure. +30 PV max.")

func add_item(item_name, amount):
	if inventory.has(item_name):
		inventory[item_name] += amount
	else:
		inventory[item_name] = amount
	update_label()

func interact_with_world():
	if current_zone == "Village":
		var merchant_distance = global_position.distance_to(Vector2(220, 150))
		if merchant_distance < 55:
			print("\n=== MARCHAND ===")
			print("H: Potion (10 or)")
			print("E: Épée (25 or)")
			print("A: Armure (40 or)")
			if Input.is_key_pressed(KEY_H):
				buy_potion()
			if Input.is_key_pressed(KEY_E):
				buy_sword()
			if Input.is_key_pressed(KEY_A):
				buy_armor()
			return
		if global_position.distance_to(Vector2(120, 100)) < 45:
			print("\n=== CHEF DU VILLAGE ===")
			print("Le roi des montagnes a libéré un dragon!")
			print("Va le vaincre dans la grotte finale!")
			return
	if current_zone == "Forêt":
		if global_position.distance_to(Vector2(490, 160)) < 50:
			print("\n=== GUIDE FORESTIER ===")
			print("Des créatures rôdent ici. Sois prudent.")
			return
	if current_zone == "Grotte":
		if global_position.distance_to(Vector2(850, 200)) < 50:
			print("\n=== ENTRÉE DE LA GROTTE ===")
			print("Une aura menaçante provient des profondeurs...")
			add_item("Pierre de pouvoir", 1)
			return
	if current_zone == "Caverne du Dragon":
		if global_position.distance_to(Vector2(950, 450)) < 60:
			print("\n=== LE DRAGON APPARAÎT ===")
			print("BOSS: Dragon Ancien!")
			return
	print("Rien à interagir ici.")

func open_inventory_menu():
	print("\n=== INVENTAIRE ===")
	for item in inventory.keys():
		if inventory[item] > 0:
			print(item + ": " + str(inventory[item]))
	print("Or: " + str(gold))
	print("Niveau: " + str(level))
	print("XP: " + str(experience) + "/" + str(experience_to_level))
	print("==================")

func get_save_data():
	return {
		"hp": hp,
		"max_hp": max_hp,
		"gold": gold,
		"damage": damage,
		"potion_count": potion_count,
		"inventory": inventory,
		"current_zone": current_zone,
		"level": level,
		"experience": experience,
		"quest_progress": quest_progress,
		"quest_done": quest_done,
		"position": {"x": position.x, "y": position.y},
	}

func load_save_data(data):
	if data == null:
		return
	if "hp" in data:
		hp = int(data["hp"])
	if "max_hp" in data:
		max_hp = int(data["max_hp"])
	if "gold" in data:
		gold = int(data["gold"])
	if "damage" in data:
		damage = int(data["damage"])
	if "potion_count" in data:
		potion_count = int(data["potion_count"])
	if "inventory" in data:
		inventory = data["inventory"]
	if "level" in data:
		level = int(data["level"])
	if "experience" in data:
		experience = int(data["experience"])
	if "position" in data:
		var pos = data["position"]
		position = Vector2(float(pos.get("x", 100.0)), float(pos.get("y", 100.0)))
	update_label()
