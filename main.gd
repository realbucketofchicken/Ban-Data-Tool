class_name mainNode extends Control
@export var edit_window:EditWindow
@export var punish_list_parser: PunishListParser
@export var PunishContainer:Control
@export var punish_scene:PackedScene
@export var new_punish_btn:Button
@export var file_opener:FileDialog
@export var open_btn:Button
@export var new_btn:Button
@export var save_btn:Button
@export var exporter:BanListExporter
@export var file_label:Label
@export var save_file_parser:SaveFileParser
@export var quit_confirmation:ConfirmationDialog
@export var ban_counter: Label
@export var save_label: Label
@export var plus: CPUParticles2D
@export var minus: CPUParticles2D
@export var more_btn: Button
@export var options_window: MoreOptionsWindow

var current_path:String
var unsaved:bool

func _ready() -> void:
	more_btn.pressed.connect(options_window.show)
	edit_window.changed.connect(update_ban_counter) # use as update
	
	quit_confirmation.canceled.connect(get_tree().quit)
	quit_confirmation.confirmed.connect(save_and_exit)
	get_tree().auto_accept_quit = false
	get_tree().root.close_requested.connect(close_request)
	set_file(save_file_parser.read())
	file_opener.file_selected.connect(set_file)
	open_btn.pressed.connect(file_opener.show)
	new_btn.pressed.connect(new_punishment)
	save_btn.pressed.connect(save)
	options_window.remove_dupes.connect(remove_dupes)
	options_window.save_v_one.connect(savevone)

func savevone():
	var Punishments:Array[Punishment]
	for child in PunishContainer.get_children():
		if child is PunishShowcase:
			Punishments.append(child.punishment)
	exporter.Exportv1(Punishments,current_path.rstrip(".txt")+" v1.txt")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		save()

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
		if punishment.uid != "":
			if !keys.has(punishment.uid):
				keys.append(punishment.uid)
				count += 1
		else:
			if !keys.has(punishment.username):
				keys.append(punishment.username)
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
	save_file_parser.save(current_path)
	exporter.Export(Punishments,current_path)
	unsaved = false

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
		child.queue_free()
	update_ban_counter()

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
	current_path = path
	file_label.text = path
	clear_children()
	add_punishments(path)

func close_request():
	if !unsaved:
		get_tree().quit()
	else:
		quit_confirmation.show()

func save_and_exit():
	save()
	get_tree().quit()
