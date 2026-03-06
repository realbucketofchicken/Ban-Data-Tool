class_name SaveFileParser extends Node

const savloc = "user://save.dat"

func read() -> String:
	var file = FileAccess.open(savloc,FileAccess.READ)
	if !file:
		print("no savefile found")
		return ""
	
	return file.get_as_text()

func save(current_file:String) -> void:
	var file = FileAccess.open(savloc,FileAccess.WRITE)
	if !file:
		push_error("cant write savefile")
		return
	file.store_string(current_file)
