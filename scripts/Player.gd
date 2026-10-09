extends CharacterBody2D

const SPEED = 140.0

var hp = 100
var max_hp = 100
var gold = 50
var damage = 15
var potion_count = 3
var attack_cooldown = 0.0

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

func _input(event):
	if event.is_action_pressed("attack"):
		attack_nearest_enemy()
	if event.is_action_pressed("use_potion"):
		use_potion()

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
	potion_count -= 1
	hp = min(max_hp, hp + 30)
	update_label()
	print("Tu bois une potion. +30 PV")

func update_label():
	if label:
		label.text = "PV: " + str(hp) + " / " + str(max_hp) + "\nOr: " + str(gold) + "\nPotion: " + str(potion_count)
