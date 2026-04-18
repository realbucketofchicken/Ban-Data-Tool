class_name mainNode extends Control
@export var edit_window:EditWindow
@export var punish_list_parser: PunishListParser
@export var PunishContainer:Control
@export var punish_scene:PackedScene
@export var new_punish_btn:Button
@export var new_btn:Button
@export var exporter:BanListExporter
@export var save_file_parser:SaveFileParser
@export var quit_confirmation:ConfirmationDialog
@export var ban_counter: Label
@export var plus: CPUParticles2D
@export var minus: CPUParticles2D
@export var more_btn: Button
@export var options_window: MoreOptionsWindow
@export var git: Node
@export var commit: Button
@export var save_label:Label

var current_path:String
var unsaved:bool

func _ready() -> void:
	print(ProjectSettings.globalize_path("user://repo/"))
	more_btn.pressed.connect(options_window.show)
	edit_window.changed.connect(update_ban_counter) # use as update
	
	var save_file = save_file_parser.read()
	quit_confirmation.canceled.connect(get_tree().quit)
	quit_confirmation.confirmed.connect(save_and_exit)
	get_tree().auto_accept_quit = false
	get_tree().root.close_requested.connect(close_request)
	new_btn.pressed.connect(new_punishment)
	commit.pressed.connect(save)
	options_window.remove_dupes.connect(remove_dupes)
	options_window.save_v_one.connect(savevone)
	
	options_window.repo_edit.text = save_file.get("REPO","")
	options_window.email_edit.text = save_file.get("EMAIL","")
	options_window.name_edit.text = save_file.get("NAME","")
	options_window.key_edit.text = save_file.get("KEY","")
	
	options_window.repo_edit.text_changed.connect(unsave.unbind(1))
	options_window.email_edit.text_changed.connect(unsave.unbind(1))
	options_window.name_edit.text_changed.connect(unsave.unbind(1))
	options_window.key_edit.text_changed.connect(unsave.unbind(1))
	if options_window.repo_edit.text:
		if git.has_method("Clone"):
			git.Clone()

func unsave():
	save()
	unsaved = true

func savevone():
	var Punishments:Array[Punishment]
	for child in PunishContainer.get_children():
		if child is PunishShowcase:
			Punishments.append(child.punishment)
	exporter.Exportv1(Punishments,current_path.rstrip(".txt")+" v1.txt")

var last_alts:int = 0
func remove_dupes():
	unsaved = true
	remove_loop()
	update_ban_counter()

func remove_loop():
	var found:bool = remove_iteration()
	if found == true:
		remove_loop()

func remove_iteration() -> bool:
	var punishments:Array[PunishShowcase]
	for child in PunishContainer.get_children():
		if child is PunishShowcase:
			punishments.append(child)
	for punishment_keep in punishments:
		for punishment_two in punishments:
			# cancel if not same name
			if punishment_keep == punishment_two:
				continue
			if punishment_keep.punishment.username != punishment_two.punishment.username:
				continue
			# cancel if not same uid
			if punishment_keep.punishment.uid != punishment_two.punishment.uid:
				continue
			# if there a reason?
			if punishment_keep.punishment.punish_reason == "":
				punishment_keep.punishment.punish_reason = punishment_two.punishment.punish_reason
			# is there a time set?
			if punishment_keep.punishment.punish_end == 0:
				punishment_keep.punishment.punish_end = punishment_two.punishment.punish_end
			# if its a mute maybe it should be a ban
			if punishment_keep.punishment.what_punishment == Punishment.punishment_types.MUTE:
				punishment_keep.punishment.what_punishment = punishment_two.punishment.what_punishment
			
			punishment_two.free()
			return true
	return false


func update_ban_counter():
	var punishments:Array[Punishment]
	for child in PunishContainer.get_children():
		if child is PunishShowcase:
			punishments.append(child.punishment)
	var count:int = 0
	var keys:Array[String]
	for punishment in punishments:
		if punishment.punish_reason != "BAN_EVADING":
			count += 1
	ban_counter.text = str(punishments.size()) + " Entires :::::: " + str(count) + \
						" Unique :::::: " + str(punishments.size()-count) + " Alts"
	var alts = punishments.size() - count
	if last_alts != alts:
		if alts > last_alts:
			plus.emitting = true
		else:
			minus.emitting = true
	last_alts = alts

func save():
	save_label.hide()
	var Punishments:Array[Punishment]
	for child in PunishContainer.get_children():
		if child is PunishShowcase:
			Punishments.append(child.punishment)
	update_ban_counter()
	save_file_parser.save()
	exporter.Export(Punishments,current_path)
	unsaved = false
	git.Commit_changes()

func new_punishment() -> void:
	unsaved = true
	save_label.show()
	var child:PunishShowcase = punish_scene.instantiate()
	child.punishment = Punishment.new()
	PunishContainer.add_child(child)
	child.update()
	child.Edit.connect(edit_called)
	edit_called(child,true)
	update_ban_counter()

func add_punishments(file:String):
	save_label.show()
	var punishments = punish_list_parser.parse(file)
	for punish:Punishment in punishments:
		var child:PunishShowcase = punish_scene.instantiate()
		child.punishment = punish
		PunishContainer.add_child(child)
		child.update()
		child.Edit.connect(edit_called)
	update_ban_counter()

func clear_children():
	save_label.hide()
	for child in PunishContainer.get_children():
		print("kill ",child)
		child.queue_free()
	update_ban_counter.call_deferred()

func edit_called(on:PunishShowcase,set_time:bool = false):
	save_label.show()
	unsaved = true
	edit_window.opened_from = on
	edit_window.punishment = on.punishment if on else Punishment.new()
	edit_window.update(set_time)
	edit_window.show()
	edit_window.grab_focus()
	update_ban_counter()

func set_file(path:String):
	clear_children()
	print("buh")
	current_path = path
	add_punishments(path)
	update_ban_counter.call_deferred()

func close_request():
	if !unsaved:
		git.delete_recursive("user://repo/")
		get_tree().quit()
	else:
		quit_confirmation.show()

func save_and_exit():
	save()
	git.Commit_changes()
	git.delete_recursive("user://repo/")
	await get_tree().process_frame
	get_tree().quit()
