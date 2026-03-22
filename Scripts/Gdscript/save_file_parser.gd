class_name SaveFileParser extends Node
@export var options_window: MoreOptionsWindow

const savloc = "user://save.dat"

func read() -> Dictionary:
	var file = FileAccess.open(savloc,FileAccess.READ)
	if !file:
		print("no savefile found")
		return {}
	var Dict:Dictionary = file.get_var()
	return Dict

func save(current_file:String) -> void:
	var file = FileAccess.open(savloc,FileAccess.WRITE)
	if !file:
		push_error("cant write savefile")
		return
	var Dict:Dictionary[String,Variant] = {
		"FILE":current_file,
		"REPO":options_window.repo_edit.text,
		"EMAIL":options_window.email_edit.text,
		"NAME":options_window.name_edit.text,
		"KEY":options_window.key_edit.text,
		"USE_OLD":options_window.use_old.button_pressed,
	}
	file.store_var(Dict)
