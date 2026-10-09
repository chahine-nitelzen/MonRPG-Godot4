extends CharacterBody2D

var hp = 30
var max_hp = 30
var speed = 30.0
var damage = 8
var gold_reward = 10
var xp_reward = 15
var player = null
var enemy_name = "Enemy"

@onready var progress = $ProgressBar

func _ready():
	add_to_group("enemies")
	if progress:
		progress.max_value = max_hp
		progress.value = hp

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var dist = global_position.distance_to(player.global_position)
	if dist < 100:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		if dist < 30 and hp > 0:
			var dmg = damage + randi() % 3
			player.take_damage(dmg)
			print(enemy_name + " attaque pour ", dmg, " dégâts")
	update_health_bar()

func update_health_bar():
	if progress:
		progress.value = hp
