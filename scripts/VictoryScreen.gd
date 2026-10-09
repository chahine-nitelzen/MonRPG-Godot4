extends CanvasLayer

@onready var title = $VBoxContainer/Title
@onready var message = $VBoxContainer/Message
@onready var stats = $VBoxContainer/Stats

func _ready():
	if title:
		title.text = "🏆 VICTOIRE ! 🏆"
	if message:
		message.text = "Tu as vaincu le Dragon Ancien!\n\nLe monde est sauvé!"
	if stats:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			stats.text = "Niveau final: %d\nOr total: %d\nXP total: %d\n\nAppuie sur R pour recommencer" % [player.level, player.gold, player.experience]

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
