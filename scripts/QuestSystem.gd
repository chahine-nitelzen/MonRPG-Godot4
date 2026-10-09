extends RefCounted

var title = "Tuer 3 slimes"
var progress = 0
var goal = 3
var is_complete = false

func add_progress(amount = 1):
	progress += amount
	if progress >= goal:
		is_complete = true
		progress = goal

func to_dict():
	return {
		"title": title,
		"progress": progress,
		"goal": goal,
		"is_complete": is_complete,
	}

func load_from_dict(data):
	if data == null:
		return
	title = data.get("title", title)
	progress = int(data.get("progress", 0))
	goal = int(data.get("goal", goal))
	is_complete = bool(data.get("is_complete", false))

func get_text():
	if is_complete:
		return title + " (terminée)"
	return title + " (" + str(progress) + "/" + str(goal) + ")"
