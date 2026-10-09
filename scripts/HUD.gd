extends CanvasLayer

@onready var label = $Label

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and label:
		label.text = "PV: %s/%s\nOr: %s\nPotions: %s\nZone: %s\nInventaire: %s" % [player.hp, player.max_hp, player.gold, player.potion_count, player.current_zone, player.stringify_inventory()]
