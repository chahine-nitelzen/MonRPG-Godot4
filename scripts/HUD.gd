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
			quest_text += " (terminée)"
		label.text = "PV: %s/%s\nOr: %s\nPotions: %s\nZone: %s\nQuête: %s (%s/%s)\nInventaire: %s" % [player.hp, player.max_hp, player.gold, player.potion_count, player.current_zone, quest_text, player.quest_progress, player.quest_goal, player.stringify_inventory()]
	if world and Input.is_action_just_pressed("ui_cancel"):
		world.save_game()
		print("Sauvegarde manuelle effectuée.")
