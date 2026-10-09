extends CanvasLayer

@onready var label = $Label
var world = null

func set_world(value):
	world = value

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and label:
		var quest_text = player.current_quest
		if player.quest_done:
			quest_text += " ✓"
		label.text = "Niveau %d | PV: %d/%d | Or: %d | XP: %d/%d\nZone: %s | Quête: %s (%d/%d)\nI: Inventaire" % [player.level, player.hp, player.max_hp, player.gold, player.experience, player.experience_to_level, player.current_zone, quest_text, player.quest_progress, player.quest_goal]
		
	if Input.is_action_just_pressed("ui_cancel"):
		print("Sauvegarde...")
		if world:
			world.save_game()

func save_game():
	print("Sauvegarde manuelle effectuée.")
