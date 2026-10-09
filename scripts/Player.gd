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
}
var current_zone = "Village"
var distance_to_shop = 9999.0

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
		interact_with_shop()

func update_label():
	if label:
		label.text = "PV: %s/%s\nOr: %s\nPotion: %s\nZone: %s\nInventaire: %s" % [hp, max_hp, gold, potion_count, current_zone, stringify_inventory()]

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

func interact_with_shop():
	if current_zone == "Village":
		var shop_distance = global_position.distance_to(Vector2(200, 180))
		if shop_distance < 60:
			print("Marchand : Bonjour héros !")
			print("1. Potion (10 or) - H")
			print("2. Épée (+5 dégâts) - appuie sur E")
			buy_potion()
			return
	if current_zone == "Ville":
		var shop_distance = global_position.distance_to(Vector2(780, 470))
		if shop_distance < 60:
			print("Boutique de la ville : Acheter une potion ?")
			buy_potion()
			return
	print("Tu n'es pas près d'un marchand.")
