extends VBoxContainer

@export var name_display: PackedScene
@export var server_stat_parser: ServerStatParser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	server_stat_parser.just_parsed.connect(reparse)

func reparse():
	for child in get_children():
		child.queue_free()
	var root_display:NameDisplaye = name_display.instantiate()
	root_display.label.text = "Map"
	root_display.label_2.text = "Times Played"
	add_child(root_display)
	var maps:Dictionary = {}
	for key in server_stat_parser.maps_month.keys():
		if maps.has(server_stat_parser.maps_month[key]):
			if maps[server_stat_parser.maps_month[key]] is Array:
				#var new_arr
				maps[server_stat_parser.maps_month[key]].append(key)
			else:
				maps[server_stat_parser.maps_month[key]] = [maps[server_stat_parser.maps_month[key]],key]
		else:
			maps[server_stat_parser.maps_month[key]] = key
	maps.sort()
	print(maps," gi")
	var keys = maps.keys()
	keys.reverse()
	for amount in keys:
		var display:NameDisplaye = name_display.instantiate()
		display.label_2.text = str(amount)
		var gotten = maps[amount]
		var new_string:String = ""
		if gotten is Array:
			for piece in gotten.size():
				if gotten[piece]:
					new_string += gotten[piece] + (", " if piece != gotten.size()-1 else "")
		else:
			new_string = gotten
		display.label.text = str(new_string)
		add_child(display)
