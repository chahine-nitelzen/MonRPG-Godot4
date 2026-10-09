extends CharacterBody2D

var hp = 150
var max_hp = 150
var speed = 20.0
var damage = 20
var gold_reward = 500
var xp_reward = 300
var player = null
var enemy_name = "Dragon Ancien"
var attack_cooldown = 1.5
var attack_timer = 0.0
var defeated = false

@onready var progress = $ProgressBar

func _ready():
	add_to_group("boss")
	if progress:
		progress.max_value = max_hp
		progress.value = hp
	print("BOSS APPARAÎT: Dragon Ancien!")

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if player == null or defeated:
		return

	attack_timer -= delta
	var dist = global_position.distance_to(player.global_position)

	if dist < 150:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		if attack_timer <= 0 and dist < 60 and hp > 0:
			var dmg = damage + randi() % 10
			player.take_damage(dmg)
			print("DRAGON attaque pour ", dmg, " dégâts massifs!")
			attack_timer = attack_cooldown

	update_health_bar()

func update_health_bar():
	if progress:
		progress.value = max(0, hp)

func on_defeat():
	if not defeated:
		defeated = True
		print("\n=== DRAGON VAINCU ===")
		print("Tu as terrassé le Dragon Ancien!")
		print("Or: +", gold_reward)
		print("XP: +", xp_reward)
		print("======================\n")
		if player:
			player.gold += gold_reward
			player.add_experience(xp_reward)
			player.quest_done = True
			player.update_label()
			get_tree().call_group("world", "on_game_victory")
		queue_free()
