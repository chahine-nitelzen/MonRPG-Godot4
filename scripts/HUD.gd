extends CanvasLayer

@onready var label = $Label

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and label:
		label.text = "PV: " + str(player.hp) + "/" + str(player.max_hp) + "   Or: " + str(player.gold) + "   Potions: " + str(player.potion_count)
