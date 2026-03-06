extends Window

@export var root:mainNode
@export var PunishContainer:Control
@export var search_bar:LineEdit
@export var total: Label
@export var alts: Label
@export var unique: Label
@export var best: Label
@export var altshowcse: PackedScene
@export var altshowcse_container: Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(update_stats)
	update_stats()
	close_requested.connect(hide)
	root.edit_window.changed.connect(update_stats)

func update_stats():
	for child in altshowcse_container.get_children():
		child.queue_free()
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
	var entires_stats:Dictionary[Punishment,int]
	for punishment in punishments:
		if punishment.uid:
			for punishment2 in punishments:
				if punishment2 != punishment:
					if punishment2.uid == punishment.uid:
						if entires_stats.has(punishment):
							entires_stats[punishment] += 1
						else:
							entires_stats[punishment] = 1
	var most_evader:Punishment
	var most_alts:int = -1
	var used_uids:Array[String] = []
	sort_dict(entires_stats)
	for entry in entires_stats.keys():
		if entires_stats[entry] > most_alts:
			print("new best: ",entires_stats[entry] )
			most_evader = entry
			most_alts = entires_stats[entry]
	
	
		if entry is Punishment:
			if entry.uid not in used_uids:
				used_uids.append(entry.uid)
				var child:altshowcase = altshowcse.instantiate()
				altshowcse_container.add_child(child)
				child.count_label.text = "%s alts" % entires_stats[entry]
				child.name_label.text = entry.username
				child.uid_label.text = entry.uid
				child.search_alts_button.pressed.connect(root_search.bind(child.uid_label.text))
	total.text = "Total punishments %s" % str(punishments.size())
	unique.text = "Unique people: %s" % str(count)
	alts.text = "Alts total: %s" % str(punishments.size()-count)
	if most_evader:
		best.text = "Most alt accounts: %s (%s)" % [most_evader.username, most_evader.uid]

func root_search(what:String):
	search_bar.text = what
	search_bar.text_changed.emit(what)

func sort_dict(dict: Dictionary) -> void:
	var pairs = dict.keys().map(func (key): return [key, dict[key]])
	pairs.sort()
	pairs.reverse()
	dict.clear()
	for p in pairs:
		dict[p[0]] = p[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
