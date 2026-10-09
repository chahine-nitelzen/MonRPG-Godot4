extends CharacterBody2D

const SPEED = 140.0

var hp = 100
var max_hp = 100
var gold = 60
var damage = 15
var potion_count = 3
var attack_cooldown = 0.0
var inventory = {
	"Potion": 3,
	"Épée": 1,
	"Armure": 0,
	"Herbe": 0,
}
var current_zone = "Village"
var current_quest = "Tuer 3 slimes"
var quest_progress = 0
var quest_goal = 3
var quest_done = false
var quest_system = null
var save_system = null

@onready var label = $Label

func _ready():
	add_to_group("player")
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

func update_label():
	if label:
		var quest_text = current_quest
		if quest_done:
			quest_text += " (terminée)"
		label.text = "PV: %s/%s\nOr: %s\nPotion: %s\nZone: %s\nQuête: %s (%s/%s)\nInventaire: %s" % [hp, max_hp, gold, potion_count, current_zone, quest_text, quest_progress, quest_goal, stringify_inventory()]

func stringify_inventory():
	var result = []
	for item in inventory.keys():
		if inventory[item] > 0:
			result.append(item + " x" + str(inventory[item]))
	if result.is_empty():
		return "vide"
	return ", ".join(result)

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
		nearest.hp -= damage
		print("Tu frappes ", nearest.name, " pour ", damage, " dégâts.")
		if nearest.hp <= 0:
			nearest.queue_free()
			gold += nearest.gold_reward
			if get_tree().has_group("world"):
				get_tree().call_group("world", "on_enemy_defeated", nearest.enemy_name)
			print("Ennemi tué ! +", nearest.gold_reward, " or")
		update_label()
	else:
		print("Aucun ennemi proche.")

func take_damage(amount):
	hp -= amount
	hp = max(0, hp)
	update_label()
	if hp <= 0:
		print("Tu es mort !")
		hp = max_hp
		global_position = Vector2(100, 100)

func use_potion():
	if potion_count <= 0:
		print("Plus de potions")
		return
	if hp >= max_hp:
		print("Ta vie est déjà au maximum")
		return
	potion_count -= 1
	hp = min(max_hp, hp + 30)
	update_label()
	print("Tu bois une potion. +30 PV")

func buy_potion():
	if gold < 10:
		print("Tu n'as pas assez d'or pour acheter une potion.")
		return
	gold -= 10
	potion_count += 1
	inventory["Potion"] = potion_count
	update_label()
	print("Tu achètes une potion pour 10 or.")

func buy_axe():
	if gold < 20:
		print("Tu n'as pas assez d'or pour acheter une épée.")
		return
	gold -= 20
	damage += 5
	inventory["Épée"] += 1
	update_label()
	print("Tu achètes une meilleure épée. +5 dégâts.")

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
			print("Marchand : Bonjour héros !")
			print("- H: acheter une potion (10 or)")
			print("- E: acheter une épée (20 or)")
			if Input.is_key_pressed(KEY_H):
				buy_potion()
			if Input.is_key_pressed(KEY_E):
				buy_axe()
			return
		if global_position.distance_to(Vector2(120, 100)) < 45:
			print("Chef du village: Va tuer 3 slimes dans la forêt !")
			return
	if current_zone == "Forêt":
		if global_position.distance_to(Vector2(490, 160)) < 50:
			print("Tu sens des slimes autour de toi...")
			return
	if current_zone == "Grotte":
		if global_position.distance_to(Vector2(850, 200)) < 50:
			print("Tu trouves une pierre de pouvoir !")
			add_item("Pierre", 1)
			return
	print("Rien à interagir ici.")

func get_save_data():
	return {
		"hp": hp,
		"max_hp": max_hp,
		"gold": gold,
		"damage": damage,
		"potion_count": potion_count,
		"inventory": inventory,
		"current_zone": current_zone,
		"current_quest": current_quest,
		"quest_progress": quest_progress,
		"quest_goal": quest_goal,
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
	if "current_zone" in data:
		current_zone = str(data["current_zone"])
	if "current_quest" in data:
		current_quest = str(data["current_quest"])
	if "quest_progress" in data:
		quest_progress = int(data["quest_progress"])
	if "quest_goal" in data:
		quest_goal = int(data["quest_goal"])
	if "quest_done" in data:
		quest_done = bool(data["quest_done"])
	if "position" in data:
		var pos = data["position"]
		position = Vector2(float(pos.get("x", 100.0)), float(pos.get("y", 100.0)))
	update_label()
