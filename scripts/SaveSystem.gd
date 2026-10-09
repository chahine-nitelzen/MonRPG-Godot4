extends RefCounted

var save_path = "user://savegame.json"

func save_player(player):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		print("Impossible d'écrire la sauvegarde : ", FileAccess.get_open_error())
		return
	var payload = player.get_save_data()
	file.store_string(JSON.stringify(payload))
	file.close()
	print("Sauvegarde écrite dans ", save_path)

func load_player(player):
	if not FileAccess.file_exists(save_path):
		print("Aucune sauvegarde trouvée.")
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		print("Impossible de lire la sauvegarde : ", FileAccess.get_open_error())
		return
	var json = JSON.new()
	var parse_error = json.parse(file.get_as_text())
	file.close()
	if parse_error != OK:
		print("Erreur de lecture JSON.")
		return
	player.load_save_data(json.data)
	print("Sauvegarde chargée.")
