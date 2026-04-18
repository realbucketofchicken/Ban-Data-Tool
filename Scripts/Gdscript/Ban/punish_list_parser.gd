class_name PunishListParser extends Node

func parse(file:String) -> Array[Punishment]:
	if !file:
		return []
	var fileaccess:FileAccess = FileAccess.open(file,FileAccess.READ)
	if fileaccess == null:
		printerr("no access to file: fileaccess == null")
		return []
	var raw:String = fileaccess.get_as_text()
	var lines:PackedStringArray = raw.split("\n")
	var punishments:Array[Punishment]
	var formatting:bool = false
	for line in lines:
		var splits:PackedStringArray = line.split(": ")
		if line.contains(":") and !line.contains(": "):
			push_error("WARNING, INCORRECT FORMATTING")
			formatting = true
			splits = line.split(":")
		match splits[0]:
			"L!ListBegin":
				print("start")
			"NAME":
				var new_punish:Punishment = Punishment.new()
				new_punish.username = splits[1]
				punishments.append(new_punish)
			"UID":
				punishments[-1].uid = splits[1]
			"PUNISHMENT":
				var punish:Punishment.punishment_types = punish_text_to_enum(splits[1])
				punishments[-1].what_punishment = punish
			"REASON":
				punishments[-1].punish_reason = splits[1]
			"END_DATE":
				punishments[-1].punish_end = splits[1].to_int()
			"L!ListEnd":
				break
	if formatting:
		OS.alert("This file contains incorret formatting, things might not load correctly!")
	return punishments

func punish_text_to_enum(text) -> Punishment.punishment_types:
	var punish:Punishment.punishment_types
	match text:
		"BAN":
			punish = Punishment.punishment_types.BAN
		"MUTE":
			punish = Punishment.punishment_types.MUTE
		"WARN":
			punish = Punishment.punishment_types.WARN
	return punish
